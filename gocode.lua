scite_Command {
  'Go Autocomplete|go_autocomplete|Ctrl+,'
}

local esc = string.char(27)

local function handle_key(ch)
  if ch ~= esc then
    editor:AutoCSelect(ch)
  end
end

function go_autocomplete()
  local file, pos = props['FilePath'], editor.CurrentPos
  local text = editor:GetText()
  local tmp = file .. '~~~~~~'
  local f = io.open(tmp, "wb")
  f:write(text:gsub("\r", ""))
  f:close()

  local cmd = ('gocode -in=%s autocomplete %s %d'):format(tmp, file, pos)
  local gocode = scite_Popen(cmd)
  gocode:read()
  local list = {}
  for line in gocode:lines() do
    line = line:gsub('^%s+%a+%s+','')
    table.insert(list, line)
  end
  gocode:close()

  os.remove(tmp)
  if #list > 0 then
    scite_OnChar('once', handle_key)
    editor.AutoCAutoHide = false
    scite_UserListShow(list, 1, function(s)
      scite_OnChar(handle_key, 'remove')
      editor.AutoCAutoHide = true
      local name = s:match('([%w_]+)')
      local prefix = scite_WordAtPos()
      if prefix then name = name:sub(string.len(prefix)+1) end
      editor:InsertText(-1, name)
      editor:CallTipShow(pos, s)
      editor:GotoPos(pos + #name)
    end)
  end
end

-- vim: et sw=2 ts=2
