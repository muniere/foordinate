require "option_parser"
require "logger"
require "../lib"

#
# Application
#
class Application

  #
  # Run application
  #
  # @param args CLI arguments
  #
  def run(args : Array(String))
    # blocking IO
    STDOUT.blocking = true
    STDERR.blocking = true

    # parse
    begin
      context = self.parse(args)
    rescue e
      abort e.message
    end

    # count
    action = Count.new
    action.logger = context.logger
    action.run(context.pathnames)
    exit 0
  end

  #
  # Parse CLI arguments
  #
  # @param args CLI arguments
  # @return Parsed context
  #
  def parse(args : Array(String)) : Context

    context = Context.new

    # parse
    parser = OptionParser.new
    parser.banner = "Usage: #{File.basename($0)} [options] <directory> [<directory> ...]"

    parser.on("-a", "--all", "Include hidden directories") do
      context.all = true
    end

    parser.on("-p string", "--pattern=string", "Pattern to filter files") do |v|
      context.pattern = v
    end

    parser.on("-v", "--verbose", "Show verbose messages") do
      context.verbose += 1
    end

    parser.on("-h", "--help", "Show this help") do
      STDERR.puts(parser)
      exit 0
    end

    argv = parser.parse(args) as Array(String)

    # logger
    if context.verbose > 0
      context.logger.level = Logger::DEBUG
    else
      context.logger.level = Logger::WARN
    end

    # validate
    if argv.empty?
      paths = Dir.glob("*")
    else
      paths = argv
    end

    context.pathnames = paths.map { |path| Pathname.new(path) }

    return context
  end
end

#
# Value context
#
struct Context

  # args
  property pathnames :: Array(Pathname)

  # opts
  property all     :: Bool
  property pattern :: String
  property verbose :: Int
  property logger  :: Logger

  #
  # Initialize context
  #
  def initialize(
    @pathnames = Array(Pathname).new,
    @all       = false,
    @pattern   = nil,
    @verbose   = 0,
    @logger    = Logger.create(STDERR),
  )
  end
end

if PROGRAM_NAME == $0
  Application.new.run(ARGV)
end
