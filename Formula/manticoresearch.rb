class Manticoresearch < Formula
  desc "Open source text search engine"
  homepage "https://www.manticoresearch.com"
  url "https://ghproxy.com/https://github.com/manticoresoftware/manticoresearch/archive/refs/tags/6.0.4.tar.gz"
  sha256 "5081f4f60152d041f14fdaf993f4cc67b127e76c970b58db9bc9532cd1325d8a"
  license "GPL-2.0-only"
  revision 1
  version_scheme 1
  head "https://github.com/manticoresoftware/manticoresearch.git", branch: "master"

  # Only even patch versions are stable releases
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+\.\d*[02468])$/i)
  end

  bottle do
    sha256 arm64_ventura:  "420b934e75df2c536c6de9f55ea99d47aa9ccb1409e61fc409fdb9e63997db00"
    sha256 arm64_monterey: "29b92066aa0a3f7b3dd1bc2c6b8bf368630435b98b0ebed4181c63382006152e"
    sha256 arm64_big_sur:  "f97564ecc00b013f65e7553d8904fe1602a6c40100673b108f312aef5bed5d22"
    sha256 ventura:        "efe7756b1290d1ef3a3a6f1b6e7b5e6bcca60c79c882cb5060110128669c6eef"
    sha256 monterey:       "e74a51ab97c803eff41fedddb46758194e198913f9893714ca57384ee0819414"
    sha256 big_sur:        "83d17d130e4a748978b1d4a34214e49db94b453cf4964c03b93430703117d50a"
    sha256 x86_64_linux:   "7f162c59a73c8208848ca34172100bd662c981e35aed6195cb5330b88a311d7b"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "icu4c"
  depends_on "libpq"
  depends_on "mysql-client"
  depends_on "openssl@1.1"
  depends_on "unixodbc"
  depends_on "zstd"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  conflicts_with "sphinx", because: "manticoresearch is a fork of sphinx"

  fails_with gcc: "5"

  def install
    # ENV["DIAGNOSTIC"] = "1"
    ENV["ICU_ROOT"] = Formula["icu4c"].opt_prefix.to_s
    ENV["OPENSSL_ROOT_DIR"] = Formula["openssl"].opt_prefix.to_s
    ENV["MYSQL_ROOT_DIR"] = Formula["mysql-client"].opt_prefix.to_s
    ENV["PostgreSQL_ROOT"] = Formula["libpq"].opt_prefix.to_s

    args = %W[
      -DDISTR_BUILD=homebrew
      -DWITH_ICU_FORCE_STATIC=OFF
      -D_LOCALSTATEDIR=#{var}
      -D_RUNSTATEDIR=#{var}/run
      -D_SYSCONFDIR=#{etc}
    ]

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  def post_install
    (var/"run/manticore").mkpath
    (var/"log/manticore").mkpath
    (var/"manticore/data").mkpath

    # Fix old config path (actually it was always wrong and never worked; however let's check)
    mv etc/"manticore/manticore.conf", etc/"manticoresearch/manticore.conf" if (etc/"manticore/manticore.conf").exist?
  end

  service do
    run [opt_bin/"searchd", "--config", etc/"manticoresearch/manticore.conf", "--nodetach"]
    keep_alive false
    working_dir HOMEBREW_PREFIX
  end

  test do
    (testpath/"manticore.conf").write <<~EOS
      searchd {
        pid_file = searchd.pid
        binlog_path=#
      }
    EOS
    pid = fork do
      exec bin/"searchd"
    end
  ensure
    Process.kill(9, pid)
    Process.wait(pid)
  end
end