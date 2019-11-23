require "logger"
require "colorize"

#
# Extension of standard Logger class
#
class Logger

  #
  # Construct a new logger
  #
  # @param io IO for logger
  # @return New logger
  #
  def self.create(io : IO) : Logger
    logger = Logger.new(io)
    logger.formatter = Logger::Formatter.new do |severity, datetime, progname, message|
      c = self.color(severity)
      io << "[#{severity.to_s.ljust(5)}] #{message}".colorize(c)
    end

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
