require 'ostruct'

module LuckySample
  module Config
    def self.create
      ostruct = OpenStruct.new
      # configuration file
      ostruct.config_filename = ENV['CONFIG_FILENAME'] ||
        File.expand_path(".config/lucky_sample/config.yml", Dir.home)
      ostruct.config = YAML.load_file(config_filename)

      # paths to search for samples in
      ostruct.sample_paths = ostruct.config['sample_paths'] || []

      # list of files to exclude following a pattern, of full path names
      #   EG.
      #     Blacklist patterns are used to exclude patterns of complete path names,
      #     /primeloops/i
      #
      # Since this is loaded from YAML, regexp must be prefixed with !ruby/regexp
      #   EG.
      #     !ruby/regexp /primeloops/i
      ostruct.blacklist_patterns = ostruct.config['blacklist_patterns'] || []

      # list of words or phrases that should be excluded in filenames
      # unlike blacklist_patterns, this will drop files that include any of the words
      #   EG.
      #     Lucky sample has its own default prefix which is used to exclude specific
      #     files.
      #     [!ls]SampleThatShouldntBeIncluded.wav
      ostruct.exclusions = ostruct.config['exclusions'] || []

      # Since its painful to collect the samples every time the program is ran,
      # a sample map is generated with paths to all samples
      ostruct.sample_map_path = ENV['SAMPLE_MAP_FILENAME'] ||
        File.expand_path("sample_map.yml", Dir.home)

      ostruct
    end
  end
end
