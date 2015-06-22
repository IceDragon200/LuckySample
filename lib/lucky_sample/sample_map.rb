require 'yaml'

module LuckySample
  def self.generate_sample_map(config)
    samples = []
    exts = %w(wav mp3 ogg aif aiff flac)
    exts += exts.map(&:upcase)
    file_pattern = "**/*.{#{exts.join(,)}}"
    config.sample_paths.each do |pathname|
      Dir.chdir(pathname) do
        Dir.glob(file_pattern) do |filename|
          next if config.blacklist_patterns.any? { |p| p === filename }
          next if config.exclusions.any? { |s| filename.include?(s) }
          samples << File.expand_path(filename)
        end
      end
    end
    File.write(config.sample_map_path, samples.to_yaml)
    samples
  end
end
