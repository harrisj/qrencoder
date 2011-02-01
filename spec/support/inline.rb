require 'tempfile'
temp = Tempfile.new('ruby_inline', '/tmp')
dir = temp.path
temp.delete
Dir.mkdir(dir, 0755)
ENV['INLINEDIR'] = dir
