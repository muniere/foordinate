require "logger"
require "colorize"

#
# Extension of standard Logger class
#
class Logger(T)

  #
  # Construct a new logger
  #
  # @param io IO for logger
  # @return New logger
  #
  def self.create(io : T) : Logger
    logger = Logger.new(io)
    logger.formatter = -> (severity : String, datetime : Time, progname : String, message : String, io : IO) {
      c = self.color(Severity.parse?(severity) || Severity::DEBUG)
      io << "[#{severity.ljust(5)}] #{message}".colorize(c)
    }
    return logger
  end

  #
  # Select a color for severity
  #
  # @param severity
  # @return Symbol of color
  #
  protected def self.color(severity : Severity) : Symbol
    return {
      Severity::FATAL => :red,
      Severity::ERROR => :red,
      Severity::WARN  => :yellow,
      Severity::INFO  => :cyan,
      Severity::DEBUG => :green,
    }[severity]? || :white
  end
end
