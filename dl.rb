require 'open-uri'
require 'digest/md5'
require 'fileutils'
require 'zlib'

$simple = true

Zlib::GzipReader.open('mokuroku.csv.gz').each_line {|l|
  #next unless rand(1) == 0
  (path, date, size, md5) = l.strip.split(',')
  url = "http://cyberjapandata.gsi.go.jp/xyz/dem/#{path}"
  dst_path = "dem/#{path}"
  #next unless (17..17).include?(path.split('/')[0].to_i)
  if File.exist?("#{dst_path}") && Digest::MD5.file(dst_path) == md5
    print $simple ? '-' : "skipped #{url}.\n"
    next
  end
  buf = open(url).read
  buf_md5 = Digest::MD5.hexdigest(buf)
  if md5 != buf_md5
    print $simple ? 'x' : <<-EOS
different MD5: #{url}
  #{md5}, #{size}B for mokuroku
  #{buf_md5}, #{buf.size}B from the web
    EOS
    if File.exist?(dst_path)
      FileUtils.rm(dst_path)
      print $simple ? 'k' : "deleted #{dst_path}.\n"
    end
  end
  [File.dirname(dst_path)].each{|it|
    FileUtils.mkdir_p(it) unless File.directory?(it)
  }
  File.open("#{dst_path}", 'w') {|w| w.print buf}
  print $simple ? 'o' : "Downloaded #{dst_path}#{'.' * (buf.size / 1000)}\n"
  #sleep rand(3)
}
