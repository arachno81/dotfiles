local M = {}

M.flash_and_send = function()
  local bufnr = vim.api.nvim_get_current_buf()
  local ns_id = vim.api.nvim_create_namespace("sonicpi_flash")

  -- ピンク系のカスタムハイライトを定義（1回だけでOK）
  vim.api.nvim_set_hl(0, "SonicFlashPink", {
    bg = "#ff66cc", -- Sonic Pi的なピンク
    fg = "#000000", -- 見やすさのために黒字（無視してもOK）
    bold = true,
  })

  -- 全行にピンクハイライトを付ける
  local lines = vim.api.nvim_buf_line_count(bufnr)
  for i = 0, lines - 1 do
    vim.api.nvim_buf_add_highlight(bufnr, ns_id, "SonicFlashPink", i, 0, -1)
  end

  -- 0.6秒後に消去（←発光時間を少し長めに設定）
  vim.defer_fn(function()
    vim.api.nvim_buf_clear_namespace(bufnr, ns_id, 0, -1)
  end, 600)

  -- Sonic Pi にコード送信
  require('sonicpi.remote').run_current_buffer()
end

return M
