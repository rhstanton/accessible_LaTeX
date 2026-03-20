-- rsbibsplit.lua
-- Read jobname.bbl, split into chunks of rs_bibmax \bibitem entries,
-- write each chunk as jobname-bibchunkN.tex, define \RS@bibchunklist.

function rs_split_bbl(bblfile, bibmax)
  -- derive output directory from bbl path
  local outdir = (bblfile:match("^(.*/)") or ""):gsub("//", "/")
  texio.write_nl("RS BIB LUA: bblfile=" .. bblfile .. " outdir='" .. outdir .. "'")

  local f = io.open(bblfile, "r")
  if not f then
    texio.write_nl("RS BIB LUA: cannot open " .. bblfile)
    return
  end
  local content = f:read("*a")
  f:close()

  local widest = content:match("\\begin{thebibliography}{(.-)}")  or "9"
  texio.write_nl("RS BIB LUA: widest=" .. widest)

  -- extract body between \begin{thebibliography}{...} and \end{thebibliography}
  local body = content:match("\\begin{thebibliography}%b{}" .. "(.-)" .. "\\end{thebibliography}")
  if not body then
    texio.write_nl("RS BIB LUA: no thebibliography body found in " .. bblfile)
    tex.sprint("\\def\\RS@bibchunklist{}")
    return
  end

  -- split body on \bibitem boundaries; preamble = text before first \bibitem
  local preamble = ""
  local items = {}
  local pos = 1
  local first_bibitem = body:find("\\bibitem", 1, true)
  if first_bibitem and first_bibitem > 1 then
    preamble = body:sub(1, first_bibitem - 1)
    pos = first_bibitem
  end

  while pos <= #body do
    local next_pos = body:find("\\bibitem", pos + 1, true)
    local item_text
    if next_pos then
      item_text = body:sub(pos, next_pos - 1)
      pos = next_pos
    else
      item_text = body:sub(pos)
      pos = #body + 1
    end
    table.insert(items, item_text)
  end

  texio.write_nl("RS BIB LUA: total items=" .. #items)

  -- group into chunks and write files
  local chunks = {}
  local chunk_idx = 0
  local i = 1
  while i <= #items do
    chunk_idx = chunk_idx + 1
    local fname = outdir .. tex.jobname .. "-bibchunk" .. chunk_idx .. ".tex"
    local g = io.open(fname, "w")
    if not g then
      texio.write_nl("RS BIB LUA: ERROR cannot write " .. fname)
    else
      g:write(preamble)
      for j = i, math.min(i + bibmax - 1, #items) do
        g:write(items[j])
      end
      g:close()
      local n = math.min(i + bibmax - 1, #items) - i + 1
      texio.write_nl("RS BIB LUA: wrote " .. fname .. " (" .. n .. " items)")
      table.insert(chunks, fname)
    end
    i = i + bibmax
  end

  -- Write a driver file that inputs each chunk inside a References frame
  local driver = outdir .. tex.jobname .. "-bibdriver.tex"
  local d = io.open(driver, "w")
  if not d then
    texio.write_nl("RS BIB LUA: ERROR cannot write driver " .. driver)
    return
  end
  for _, fname in ipairs(chunks) do
    d:write("\\begin{frame}{References}\n")
    -- d:write("  \\footnotesize\n")
    d:write("  \\begin{thebibliography}{" .. widest .. "}\n")
    d:write("    \\setlength\\itemsep{2pt}\\setlength\\parsep{0pt}\n")
    d:write("    \\input{" .. fname .. "}\n")
    d:write("  \\end{thebibliography}\n")
    d:write("\\end{frame}\n")
  end
  d:close()
  texio.write_nl("RS BIB LUA: wrote driver " .. driver .. " (" .. #chunks .. " frames)")
end
