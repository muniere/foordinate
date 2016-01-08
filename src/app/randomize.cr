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

    # rename
    rename = Rename.new
    rename.logger = context.logger
    rename.randomize(context.pathnames, options: context.options)
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

    parser.on("-l number", "--length=number", "Length of new file names") do |v|
      context.options.length = v.to_i
    end

    parser.on("-p string", "--prefix=string", "Use prefix for new names") do |v|
      context.options.prefix = v
    end

    parser.on("-n", "--dry-run", "Do not perform actually") do
      context.options.dry_run = true
    end

    parser.on("--overwrite", "Overwrite existing files") do
      context.options.overwrite = true
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
      raise ArgumentError.new(parser.to_s)
    end

    context.pathnames = argv.map { |path| Pathname.new(path) }

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
  property options :: Rename::RandomizeOptions
  property dry_run :: Bool
  property verbose :: Int
  property logger  :: Logger

  #
  # Initialize context
  #
  def initialize(
    @pathnames = Array(Pathname).new,
    @options   = Rename::RandomizeOptions.new,
    @dry_run   = false,
    @verbose   = 0,
    @logger    = Logger.create(STDERR),
  )
  end
end

if PROGRAM_NAME == $0
  Application.new.run(ARGV)
end
