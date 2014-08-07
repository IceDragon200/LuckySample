require_relative 'core'

def rotate_featured
  FileUtils::Verbose.mkdir_p(File.expand_path("data/featured", LUCKY_ROOT))
  FileUtils::Verbose.cp(File.expand_path("featured.yml", LUCKY_ROOT),
                        File.expand_path("data/featured/featured-#{t}.yml", LUCKY_ROOT))
end

def make_samples(t)
  `ruby "/home/icy/docs/codes/IceDragon/kana/LuckySamples/bin/kana-lucky_samples" -s #{t} -f "#{IndexFormat.pack_link_full(t)}"`

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
  eruby = Erubis::Eruby.new(File.read(File.expand_path("index.html.erb", LUCKY_ROOT)))
  data = {
    last: read_last_seed,
    current: read_current_seed,
    featured: read_featured,
  }
  data[:current_pack] = pack_link(data[:current])
  data[:last_pack] = pack_link(data[:last])
  data[:sample_pack_history] = read_sample_pack_history

  File.write(File.expand_path("index.html", LUCKY_ROOT),
             eruby.result(data))
  STDERR.puts "Refreshed index"
end
