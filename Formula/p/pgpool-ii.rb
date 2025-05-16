class PgpoolIi < Formula
  desc "PostgreSQL connection pool server"
  homepage "https:www.pgpool.netmediawikiindex.phpMain_Page"
  url "https:www.pgpool.netmediawikiimagespgpool-II-4.6.1.tar.gz"
  sha256 "0f8805d93bc40002c8019dc40ae03a71a3d144bd39f3dffe6fa01f7fc19bb8e8"
  license all_of: ["HPND", "ISC"] # ISC is only for srcutilsstrlcpy.c

  livecheck do
    url "https:www.pgpool.netmediawikiindex.phpDownloads"
    regex(href=.*?pgpool-II[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 arm64_sequoia: "0d774d83f673c97c10c8dda0010d2601c30c0503ba1703b04402228fa72f6106"
    sha256 arm64_sonoma:  "ddb5ea019862cda6838e1f7a1f43523bd93b6c124dfc0a3ef9639e25413e5af3"
    sha256 arm64_ventura: "e6b55691e0012dc832cb7da2401535d26a9f3cc95f41dc0998472520c2350394"
    sha256 sonoma:        "e5fbe3277a008d083b74c1c70c91d095ec1b5e2199ef38593025816d88b16fc7"
    sha256 ventura:       "059fc165f6b150ebe0c1d56f00d0f8398830695523656830babe2ff695155ce6"
    sha256 arm64_linux:   "883ec20e6862835cc6927698a579750596dfea4f3dc70d13bed3d477b58d4a59"
    sha256 x86_64_linux:  "7e4b2f7427759194ccaa25ea2c91eb38f10893694a9d7a932765e98bad1079ea"
  end

  depends_on "libmemcached"
  depends_on "libpq"

  uses_from_macos "libxcrypt"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https:raw.githubusercontent.comHomebrewformula-patches03cf8088210822aa2c1ab544ed58ea04c897d9c4libtoolconfigure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    system ".configure", "--sysconfdir=#{etc}",
                          "--with-memcached=#{Formula["libmemcached"].opt_include}",
                          *std_configure_args
    system "make", "install"

    # Install conf file with low enough memory limits for default `memqcache_method = 'shmem'`
    inreplace etc"pgpool.conf.sample" do |s|
      s.gsub! "#pid_file_name = 'varrunpgpoolpgpool.pid'", "pid_file_name = '#{var}pgpool-iipgpool.pid'"
      s.gsub! "#logdir = 'tmp'", "logdir = '#{var}log'"
      s.gsub! "#memqcache_total_size = 64MB", "memqcache_total_size = 1MB"
      s.gsub! "#memqcache_max_num_cache = 1000000", "memqcache_max_num_cache = 1000"
    end
    etc.install etc"pgpool.conf.sample" => "pgpool.conf"
  end

  def post_install
    (var"log").mkpath
    (var"pgpool-ii").mkpath
  end

  service do
    run [opt_bin"pgpool", "-nf", etc"pgpool.conf"]
    keep_alive true
    log_path var"logpgpool-ii.log"
    error_log_path var"logpgpool-ii.log"
  end

  test do
    cp etc"pgpool.conf", testpath"pgpool.conf"
    system bin"pg_md5", "--md5auth", "pool_passwd", "--config-file", "pgpool.conf"
  end
end