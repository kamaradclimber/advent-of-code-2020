# frozen_string_literal: true

Dir.glob(File.join(File.dirname(__FILE__), 'aoc/*.rb')).each do |file|
  require file.gsub(/.rb$/, '')
end
