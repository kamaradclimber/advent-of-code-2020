Dit.glob(File.join(__DIR__, 'aoc/*.rb')).each do |file|
  require file.gsub(/.rb$/, '')
end
