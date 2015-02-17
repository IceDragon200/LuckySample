require_relative 'core'
require 'slim'
require 'ostruct'

KANA_LUCKY_SAMPLES = 'ruby "/home/icy/docs/codes/IceDragon/kana/LuckySamples/bin/kana-lucky_samples"'

def rotate_featured(t)
  FileUtils::Verbose.mkdir_p(File.expand_path("data/featured", LUCKY_ROOT))
  FileUtils::Verbose.cp(File.expand_path("featured.yml", LUCKY_ROOT),
                        File.expand_path("data/featured/featured-#{t}.yml", LUCKY_ROOT))
end

def gen_lucky_samples(seed, filename)
  `#{KANA_LUCKY_SAMPLES} -s #{seed} -f "#{filename}"`
end

def make_samples(t)
  gen_lucky_samples t, IndexFormat.pack_link_full(t)
  update_checksums

  update_sample_pack_history

  begin
    nm = "/home/icy/.wine/drive_c/luckysample/luckysample-#{t}"
    FileUtils::Verbose.mkdir_p(nm)
    `unzip "#{IndexFormat.pack_link_full(t)}" -d "#{nm}"`
  rescue => ex
    STDERR.puts ex.inspect
    STDERR.puts ex.backtrace.join("\n")
  end
end

def refresh_index
  data = OpenStruct.new
  data.last = read_last_seed.to_s
  data.current = read_current_seed.to_s
  data.featured = read_featured

  data.current_pack = pack_link(data[:current])
  data.last_pack = pack_link(data[:last])
  data.sample_pack_history = read_sample_pack_history
  data.news = read_news
  data.checksums = read_checksums

  #eruby = Erubis::Eruby.new(File.read(File.expand_path("index.html.erb", LUCKY_ROOT)))
  #result = eruby.result(data)

  renderer = Tilt.new(File.expand_path("index.html.slim", LUCKY_ROOT))
  result = renderer.render(data)

  File.write(File.expand_path("index.html", LUCKY_ROOT), result)

  STDERR.puts "[LS] Refreshed index"
end

def refresh_stylesheets
  renderer = Tilt.new(File.expand_path("stylesheets/main.css.scss", LUCKY_ROOT))
  result = renderer.render
  File.write(File.expand_path("public/css/main.css", LUCKY_ROOT), result)

  STDERR.puts "[LS] Refreshed Stylesheets"
end
