require_relative 'core'

def rotate_featured
  FileUtils::Verbose.mkdir_p(File.expand_path("data/featured", LUCKY_ROOT))
  FileUtils::Verbose.cp(File.expand_path("featured.yml", LUCKY_ROOT),
                        File.expand_path("data/featured/featured-#{t}.yml", LUCKY_ROOT))
end

def make_samples(t)
  `ruby "/home/icy/docs/codes/IceDragon/kana/LuckySamples/bin/kana-lucky_samples" -s #{t} -f "#{IndexFormat.pack_link_full(t)}"`

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
  eruby = Erubis::Eruby.new(File.read(File.expand_path("index.html.erb", LUCKY_ROOT)))
  data = {
    last: File.read(File.expand_path("last", LUCKY_ROOT)).strip,
    current: File.read(File.expand_path("current", LUCKY_ROOT)).strip,
    featured: YAML.load_file(File.expand_path("featured.yml", LUCKY_ROOT)),
  }
  data[:current_pack] = pack_link(data[:current])
  data[:last_pack] = pack_link(data[:last])
  File.write(File.expand_path("index.html", LUCKY_ROOT),
             eruby.result(data))
  STDERR.puts "Refreshed index"
end
