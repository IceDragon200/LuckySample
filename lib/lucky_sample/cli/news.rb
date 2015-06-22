require 'lucky_sample/news'

module LuckySamples
  module Cli
    module News
      def self.run(argv)
        LuckySample::News.load
        command = argv.shift
        case command
        when 'new'
          LuckySample::News.create
        else
          abort "USAGE: #{File.basename(__FILE__)} (new)"
        end
        LuckySample::News.save
      end
    end
  end
end
