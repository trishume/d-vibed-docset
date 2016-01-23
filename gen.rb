require "nokogiri"

basedir = ARGV.shift
reldir = ARGV.shift

out = File.open("index.sql","w")
out.puts "CREATE TABLE IF NOT EXISTS searchIndex(id INTEGER PRIMARY KEY, name TEXT, type TEXT, path TEXT);"
out.puts "CREATE UNIQUE INDEX anchor ON searchIndex (name, type, path);"
Dir[File.join(basedir,"*")].each do |f|
  doc = Nokogiri::HTML(IO.read(f))
  header = doc.at_css("#maincontent > h1")
  next unless header
  type, page_name = header.text.split
  type = "Type" if type == "Alias"
  relpath = f[reldir.length+1..-1]
  out.puts "INSERT OR IGNORE INTO searchIndex(name, type, path) VALUES ('#{page_name}', #{type}, '#{relpath}');"
end
