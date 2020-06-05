

def transform_file(old_fname)
  new_fname = old_fname.gsub(/\.txt$/, '.csv')

  old_file = File.open(old_fname, "r")
  new_file = File.open(new_fname, "w")

  old_file.each_line do |line|
    translated_line = line.gsub(/\ -\ /, ', ')
    new_file.write(translated_line)
  end

  old_file.close
  new_file.close
end

Dir["*"].select { |f| f =~ /\d\d\d\d\-\d\d\-\d\d\.txt/ }.each do |old_fname|
  transform_file(old_fname)
end