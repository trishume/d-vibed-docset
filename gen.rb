require "nokogiri"

def add_item(out, header, relpath)
  type, page_name,*rest = header.text.split
  if type == "Enum" && page_name == "member"
    page_name = rest.shift
    type = "Element"
  end
  type = "Type" if type == "Alias"
  type = "Method" if type == "Function" && page_name.include?('.')
  type = "Field" if type == "Variable" && page_name.include?('.')
  puts [type, page_name, rest] unless rest.empty?
  out.puts "INSERT OR IGNORE INTO searchIndex(name, type, path) VALUES ('#{page_name}', '#{type}', '#{relpath}');"
end

basedir = ARGV.shift
reldir = ARGV.shift

out = File.open("index.sql","w")
out.puts "CREATE TABLE IF NOT EXISTS searchIndex(id INTEGER PRIMARY KEY, name TEXT, type TEXT, path TEXT);"
out.puts "CREATE UNIQUE INDEX anchor ON searchIndex (name, type, path);"
Dir[File.join(basedir,"**/*")].each do |f|
  next unless File.file?(f)
  doc = Nokogiri::HTML(IO.read(f))
  relpath = f[reldir.length+1..-1]

  header = doc.at_css("#maincontent > h1")
  next unless header
  if header.text.include?("multiple declarations")
    doc.css("#maincontent > section > h2").each do |h2|
      add_item(out, h2, relpath)
    end
  else
    add_item(out, header, relpath)
  end
end
