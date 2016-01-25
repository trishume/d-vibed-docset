task :download do
  sh "wget --recursive --page-requisites --html-extension --convert-links --restrict-file-names=windows --domains vibed.org --no-parent http://vibed.org/api/ || true"
  mkdir_p "Vibed.docset/Contents/Resources/"
  mv "vibed.org", "Vibed.docset/Contents/Resources/Documents"
end

task :restyle do
  File.open("Vibed.docset/Contents/Resources/Documents/styles/common.css","a+") do |f|
    f.puts <<-HEREDOC
      /* ADDED FOR DASH DOCSET */
      #bs-main > nav { display: none; }
      #bs-main.bs-leftnav > section { margin-left: 0 !important; }
    HEREDOC
  end
end

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
