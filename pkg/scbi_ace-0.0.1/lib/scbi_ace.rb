$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

$: << File.join(File.dirname(__FILE__),File.basename(__FILE__,File.extname(__FILE__)))

require 'indexed_ace_file'

module ScbiAce
  VERSION = '0.0.4'
end
