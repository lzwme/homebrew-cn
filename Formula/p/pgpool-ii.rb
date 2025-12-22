class PgpoolIi < Formula
  desc "PostgreSQL connection pool server"
  homepage "https://www.pgpool.net/mediawiki/index.php/Main_Page"
  url "https://www.pgpool.net/mediawiki/images/pgpool-II-4.6.5.tar.gz"
  sha256 "43dcb860e7099d3e322418378e856935f76bb4f3f09b9024c9b7d65af55e4036"
  license all_of: ["HPND", "ISC"] # ISC is only for src/utils/strlcpy.c

  livecheck do
    url "https://www.pgpool.net/mediawiki/index.php/Downloads"
    regex(/href=.*?pgpool-II[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256               arm64_tahoe:   "60b6b09cd0a727350fae10befbea86dff9aeef373b9ad56f3f0e8dbaa26db6ce"
    sha256               arm64_sequoia: "88fc5ff2c28b7031cfa956c59499aee7df0a382efd5696d0d662e903aa7f616f"
    sha256               arm64_sonoma:  "e8275ac860c072cc9404c06297181dbdbb605ae1d5e090548ec8b040f47b9175"
    sha256 cellar: :any, sonoma:        "1f4c5ea2eaf8bd4eaaa50b7833307a257ca8db3e03500f6bae7ad91866a6a7d2"
    sha256               arm64_linux:   "ef6baf222cd6756295c555275c114e5699c8d7e34dc037c06db26238c5e82212"
    sha256               x86_64_linux:  "2a2a091914ef4396bbaf7f33b98cc2af74a399eb0f588475bc64f90e3da81230"
  end

  depends_on "libmemcached"
  depends_on "libpq"

  uses_from_macos "libxcrypt"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://ghfast.top/https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    # Workaround for use of `strchrnul`, which is not available on macOS
    inreplace "src/utils/pool_process_reporting.c",
              "*(strchrnul(status[i].value, '\\n')) = '\\0';",
              "char *p = strchr(status[i].value, '\\n');\nif (p) *p = '\\\\0';"

    system "./configure", "--sysconfdir=#{etc}",
                          "--with-memcached=#{Formula["libmemcached"].opt_include}",
                          *std_configure_args
    system "make", "install"

    # Install conf file with low enough memory limits for default `memqcache_method = 'shmem'`
    inreplace etc/"pgpool.conf.sample" do |s|
      s.gsub! "#pid_file_name = '/var/run/pgpool/pgpool.pid'", "pid_file_name = '#{var}/pgpool-ii/pgpool.pid'"
      s.gsub! "#logdir = '/tmp'", "logdir = '#{var}/log'"
      s.gsub! "#memqcache_total_size = 64MB", "memqcache_total_size = 1MB"
      s.gsub! "#memqcache_max_num_cache = 1000000", "memqcache_max_num_cache = 1000"
    end
    etc.install etc/"pgpool.conf.sample" => "pgpool.conf"

    (var/"log").mkpath
    (var/"pgpool-ii").mkpath
  end

  service do
    run [opt_bin/"pgpool", "-nf", etc/"pgpool.conf"]
    keep_alive true
    log_path var/"log/pgpool-ii.log"
    error_log_path var/"log/pgpool-ii.log"
  end

  test do
    cp etc/"pgpool.conf", testpath/"pgpool.conf"
    system bin/"pg_md5", "--md5auth", "pool_passwd", "--config-file", "pgpool.conf"
  end
end