#require "erubis"
require 'fileutils'
require 'redcarpet'
require 'tilt'
require 'yaml'
require 'digest/md5'

module IndexFormat
  def self.md_file(filename)
    extensions = {
      autolink:            true,
      space_after_headers: true,
      fenced_code_blocks:  true,
      lax_spacing:         true,
      strikethrough:       true,
      superscript:         true,
      no_intra_emphasis:   true,
    }
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML.new, extensions)
    markdown.render(File.read(filename))
  end

  def self.paragraphs(str)
    #paras = []
    #last = nil
    #str.each_line do |str|
    #  if last
    #    if str.strip.empty?
    #      paras << last
    #      last = nil
    #    else
    #      last << str
    #    end
    #  else
    #    last = str
    #  end
    #end
    #paras << last if last
    #paras
    str.each_line.to_a
  end

  def self.pack_link(id)
    "packs/lucky_samples-#{id}.zip"
  end

  def self.pack_link_full(id)
    File.expand_path(pack_link(id), LUCKY_ROOT)
  end
end

def pack_link(t)
  IndexFormat.pack_link(t)
end

def current_seed_filename
  File.expand_path("data/current", LUCKY_ROOT)
end

def last_seed_filename
  File.expand_path("data/last", LUCKY_ROOT)
end

def read_current_seed
  File.read(current_seed_filename).strip.to_i rescue nil
end

def read_last_seed
  File.read(last_seed_filename).strip.to_i rescue nil
end

def write_current_seed(seed)
  File.write(current_seed_filename, seed)
end

def write_last_seed(seed)
  File.write(last_seed_filename, seed)
end

def rotate_current_seed(newseed, oldseed=read_current_seed)
  write_last_seed(oldseed)
  write_current_seed(newseed)
end

def read_featured
  YAML.load_file(File.expand_path("featured.yml", LUCKY_ROOT))
end

def sample_pack_history_filename
  File.expand_path("data/sample_pack_history.yml", LUCKY_ROOT)
end

def read_sample_pack_history
  YAML.load_file(sample_pack_history_filename)
end

def get_pack_list
  Dir.glob("#{File.expand_path("packs", LUCKY_ROOT)}/*.zip")
end

def update_sample_pack_history
  File.write(sample_pack_history_filename,
    get_pack_list.map do |fn|
      fn.gsub(/.*lucky_samples-(\d+)\.zip/, '\1')
    end.sort.to_yaml
  )
  STDERR.puts "[LS] update_sample_pack_history"
end

def read_news
  YAML.load_file(File.expand_path("data/news.yml", LUCKY_ROOT))
end

def checksums_filename
  filename = File.expand_path("data/checksums.yml", LUCKY_ROOT)
end

def write_checksums(checksums)
  File.write(checksums_filename, checksums.to_yaml)
end

def read_checksums
  YAML.load_file(checksums_filename)
end

def update_checksums
  checksums = read_checksums || {}
  for fn in get_pack_list
    id = fn.gsub(/.*lucky_samples-(\d+)\.zip/, '\1')
    checksums[id] ||= Digest::MD5.file(fn).hexdigest
  end
  write_checksums(checksums)
end
