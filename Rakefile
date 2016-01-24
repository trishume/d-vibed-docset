task :download do
  sh "wget --recursive --page-requisites --html-extension --convert-links --restrict-file-names=windows --domains vibed.org --no-parent http://vibed.org/api/ || true"
  mkdir_p "Vibed.docset/Contents/Resources/"
  mv "vibed.org", "Vibed.docset/Contents/Resources/Documents"
end

# task :restyle do
#   sh "sed -i '' 's/media only screen and (max-width: 50em)/media only screen/g' 'Vibed.docset/Contents/Resources/Documents/css/style.css'"
# end

SQLITE_DB = "Vibed.docset/Contents/Resources/docSet.dsidx"
task :gen do
  ruby "gen.rb Vibed.docset/Contents/Resources/Documents/api Vibed.docset/Contents/Resources/Documents"
  rm SQLITE_DB if File.exist?(SQLITE_DB)
  sh "sqlite3 #{SQLITE_DB} < index.sql"
end

task :archive do
  sh "tar --exclude='.DS_Store' -cvzf Vibed.tgz Vibed.docset"
  sh "zip -r Vibed.docset.zip Vibed.docset"
end

task :clean do
  rm_r "Vibed.docset/Contents/Resources/Documents"
end
