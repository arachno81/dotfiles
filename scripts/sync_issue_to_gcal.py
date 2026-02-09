import os
import re
import base64
import json
from datetime import datetime, timedelta

import requests
from google.oauth2 import service_account
from googleapiclient.discovery import build

DUE_RE = re.compile(r"^\s*due:\s*(\d{4}-\d{2}-\d{2})\s*$", re.MULTILINE)
EVENT_ID_RE = re.compile(r"<!--\s*gcal_event_id:\s*([a-zA-Z0-9_\-@]+)\s*-->")

def gh_headers(token: str) -> dict:
    return {
        "Authorization": f"Bearer {token}",
        "Accept": "application/vnd.github+json",
        "X-GitHub-Api-Version": "2022-11-28",
    }

def get_issue(repo: str, issue_number: str, token: str) -> dict:
    url = f"https://api.github.com/repos/{repo}/issues/{issue_number}"
    r = requests.get(url, headers=gh_headers(token), timeout=20)
    r.raise_for_status()
    return r.json()

def patch_issue_body(repo: str, issue_number: str, token: str, body: str) -> None:
    url = f"https://api.github.com/repos/{repo}/issues/{issue_number}"
    r = requests.patch(url, headers=gh_headers(token), json={"body": body}, timeout=20)
    r.raise_for_status()

def load_calendar_service(sa_json_b64: str):
    raw = base64.b64decode(sa_json_b64.encode("utf-8")).decode("utf-8")
    info = json.loads(raw)
    creds = service_account.Credentials.from_service_account_info(
        info,
        scopes=["https://www.googleapis.com/auth/calendar"],
    )
    return build("calendar", "v3", credentials=creds, cache_discovery=False)

def iso_date(date_str: str) -> str:
    # YYYY-MM-DD validation (basic)
    datetime.strptime(date_str, "%Y-%m-%d")
    return date_str

def main():
    repo = os.environ["GITHUB_REPOSITORY"]
    issue_number = os.environ["ISSUE_NUMBER"]
    gh_token = os.environ["GITHUB_TOKEN"]

    cal_id = os.environ["GCAL_CALENDAR_ID"]
    sa_json_b64 = os.environ["GCAL_SA_JSON_B64"]
    tz = os.environ.get("GCAL_TZ", "Asia/Tokyo")

    issue = get_issue(repo, issue_number, gh_token)
    title = issue.get("title", "").strip()
    html_url = issue.get("html_url", "")
    body = issue.get("body") or ""

    m_due = DUE_RE.search(body)
    if not m_due:
        # dueがないなら何もしない（=連携しない）
        print("No due found. Skip.")
        return

    due = iso_date(m_due.group(1))
    # 終日予定は end が翌日（exclusive）
    end_date = (datetime.strptime(due, "%Y-%m-%d") + timedelta(days=1)).strftime("%Y-%m-%d")

    m_eid = EVENT_ID_RE.search(body)
    event_id = m_eid.group(1) if m_eid else None

    service = load_calendar_service(sa_json_b64)

    summary = f"[GH] #{issue_number} {title}"
    description = f"{html_url}\n\n(Managed by GitHub Actions)"
    event_body = {
        "summary": summary,
        "description": description,
        "start": {"date": due, "timeZone": tz},
        "end": {"date": end_date, "timeZone": tz},
    }

    if event_id:
        # update
        try:
            service.events().patch(calendarId=cal_id, eventId=event_id, body=event_body).execute()
            print(f"Updated event: {event_id}")
        except Exception as e:
            # eventが消されてた等 → 作り直す
            print(f"Patch failed, recreate. reason={e}")
            event_id = None

    if not event_id:
        created = service.events().insert(calendarId=cal_id, body=event_body).execute()
        event_id = created["id"]
        print(f"Created event: {event_id}")

        # Issue本文にイベントIDを埋め込む（upsertの鍵）
        marker = f"\n\n<!-- gcal_event_id: {event_id} -->\n"
        if "<!-- gcal_event_id:" not in body:
            new_body = body.rstrip() + marker
            patch_issue_body(repo, issue_number, gh_token, new_body)
            print("Stored gcal_event_id in issue body.")

if __name__ == "__main__":
    main()
