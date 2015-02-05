task :download do
  sh "wget http://cyberjapandata.gsi.go.jp/xyz/dem/mokuroku.csv.gz"
  sh "ruby dl.rb"
end

task :clean do
  sh "rm mokuroku.csv.gz"
end
