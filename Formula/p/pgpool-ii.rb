class PgpoolIi < Formula
  desc "PostgreSQL connection pool server"
  homepage "https://www.pgpool.net/mediawiki/index.php/Main_Page"
  url "https://www.pgpool.net/mediawiki/images/pgpool-II-4.4.5.tar.gz"
  sha256 "ccd4922c8694991102a2bef64dd43f33f539f6a185bd42f218322bab0a388a60"
  # NTP license that excludes distributing "with fee"
  license :cannot_represent

  livecheck do
    url "https://www.pgpool.net/mediawiki/index.php/Downloads"
    regex(/href=.*?pgpool-II[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "856642fb2536b44d490290ba32cf1a16521c8f180cad640c6ee175bb8c794722"
    sha256 arm64_ventura:  "178b83de0bbfcc5b67650c76d3df1f54c945fd4b179cc43095f8859119eb53f8"
    sha256 arm64_monterey: "e761caa151a638a144dfeeb2e3ddbdedb962bd796b7dc19c013507942dde0cb9"
    sha256 sonoma:         "754024f41600321a112db4c9b05f830b8d147ec749eb2f085851894be8f82f4f"
    sha256 ventura:        "f617a7f34ddfd96808af6be9628928199481231d092d921e90edd9d590008750"
    sha256 monterey:       "de12a8d5fb31ed1be11fea4f0cc8a96374ac1a6ec7aacbe96652922af3ea8ebd"
    sha256 x86_64_linux:   "899c38a8245b7244e763382cb3ac6e90c84da55f8cab091cb1c757a3209b7864"
  end

  depends_on "libmemcached"
  depends_on "libpq"

  uses_from_macos "libxcrypt"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://ghproxy.com/https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-pre-0.4.2.418-big_sur.diff"
    sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
  end

  def install
    system "./configure", *std_configure_args,
                          "--sysconfdir=#{etc}",
                          "--with-memcached=#{Formula["libmemcached"].opt_include}"
    system "make", "install"

    # Install conf file with low enough memory limits for default `memqcache_method = 'shmem'`
    inreplace etc/"pgpool.conf.sample" do |s|
      s.gsub! "#pid_file_name = '/var/run/pgpool/pgpool.pid'", "pid_file_name = '#{var}/pgpool-ii/pgpool.pid'"
      s.gsub! "#logdir = '/tmp'", "logdir = '#{var}/log'"
      s.gsub! "#memqcache_total_size = 64MB", "memqcache_total_size = 1MB"
      s.gsub! "#memqcache_max_num_cache = 1000000", "memqcache_max_num_cache = 1000"
    end
    etc.install etc/"pgpool.conf.sample" => "pgpool.conf"
  end

  def post_install
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