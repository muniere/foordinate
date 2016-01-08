require "spec"
require "./spec_helper"

describe "Count" do

  it "count entires in directory (case 1)" do
    strio = String::Builder.new(capacity: 1024)
    count = Count.new(io: strio)

    count.run([Pathname.new(File.expand_path(File.join(__DIR__, "../fixt/count_spec")))])
    output = strio.to_s

    # directory / count(files) / count(directories)
    output.should match(%r(fixt/count_spec\s+2\s+3))
  end

  it "count entires in directory (case 2)" do
    strio = String::Builder.new(capacity: 1024)
    count = Count.new(io: strio)

    count.run([Pathname.new(File.expand_path(File.join(__DIR__, "../fixt/count_spec/abc")))])
    output = strio.to_s

    # directory / count(files) / count(directories)
    output.should match(%r(fixt/count_spec/abc\s+5\s+0))
  end
end
