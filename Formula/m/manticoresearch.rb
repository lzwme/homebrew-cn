class Manticoresearch < Formula
  desc "Open source text search engine"
  homepage "https:www.manticoresearch.com"
  url "https:github.commanticoresoftwaremanticoresearcharchiverefstags6.2.12.tar.gz"
  sha256 "272d9e3cc162b1fe08e98057c9cf6c2f90df0c3819037e0dafa200e5ff71cef9"
  license "GPL-2.0-only"
  version_scheme 1
  head "https:github.commanticoresoftwaremanticoresearch.git", branch: "master"

  # Only even patch versions are stable releases
  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+\.\d*[02468])$i)
  end

  bottle do
    sha256 arm64_sonoma:   "88a7ac99768a0d8313b5b0b72e05cd57ba9cf6c84316048df817f55aeb4eba6d"
    sha256 arm64_ventura:  "b03a8a5897c278984acbe7fc72fb609d49920ff764024f0c2d9714a147c4ed81"
    sha256 arm64_monterey: "2a5d9e258f58f0c799a31cf4f90f380c0b8ad096ce2102ba3920feba585d983b"
    sha256 sonoma:         "fa49091b7e8f66ff3c4753a4de19597f5bb3564eea08cd342cb69e49714a90d3"
    sha256 ventura:        "d3c65a18ffe018ee3a9d2f21e21d01e9b14ccb4ef47441a7722180203e9a99be"
    sha256 monterey:       "a389f2fc1d4e8091a9e06c40c72fcc985c7379d231cd5b648eb6087b61c646cb"
    sha256 x86_64_linux:   "29c75ee74b81ea8872de55babf0de4193e7cc15c73703f5137ffe0f35d48bc0f"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "icu4c"
  depends_on "libpq"
  depends_on "mysql-client"
  depends_on "openssl@3"
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
      -D_RUNSTATEDIR=#{var}run
      -D_SYSCONFDIR=#{etc}
    ]

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  def post_install
    (var"runmanticore").mkpath
    (var"logmanticore").mkpath
    (var"manticoredata").mkpath

    # Fix old config path (actually it was always wrong and never worked; however let's check)
    mv etc"manticoremanticore.conf", etc"manticoresearchmanticore.conf" if (etc"manticoremanticore.conf").exist?
  end

  service do
    run [opt_bin"searchd", "--config", etc"manticoresearchmanticore.conf", "--nodetach"]
    keep_alive false
    working_dir HOMEBREW_PREFIX
  end

  test do
    (testpath"manticore.conf").write <<~EOS
      searchd {
        pid_file = searchd.pid
        binlog_path=#
      }
    EOS
    pid = fork do
      exec bin"searchd"
    end
  ensure
    Process.kill(9, pid)
    Process.wait(pid)
  end
end