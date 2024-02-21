class Manticoresearch < Formula
  desc "Open source text search engine"
  homepage "https:www.manticoresearch.com"
  url "https:github.commanticoresoftwaremanticoresearcharchiverefstags6.2.12.tar.gz"
  sha256 "272d9e3cc162b1fe08e98057c9cf6c2f90df0c3819037e0dafa200e5ff71cef9"
  license "GPL-2.0-only" # License changes in the next release and must be removed from formula_license_mismatches
  version_scheme 1
  head "https:github.commanticoresoftwaremanticoresearch.git", branch: "master"

  # Only even patch versions are stable releases
  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+\.\d*[02468])$i)
  end

  bottle do
    rebuild 1
    sha256 arm64_sonoma:   "0cc046b5cec86646a14c85aa5912465b1a5fea4cb5eded6599a0e5320d80884d"
    sha256 arm64_ventura:  "8caa6cd9d7b1c85d188f9174746d47b308824e0a4face7acae24c14893065dee"
    sha256 arm64_monterey: "056e5b48bdbf0c3891d9aa5c2e35924e1a7be5f313b1aaadf0c651f5d365a5c4"
    sha256 sonoma:         "f018a01c3c6f9d2b11e92db1a2f63ad0444a1c4fca47b37289a804b949eb0392"
    sha256 ventura:        "8fab6c51980f36da634f377c46858acb36b238b406bd9a45313d518c0a6d98d9"
    sha256 monterey:       "07ad63c44efc781704cbec24f835d39c89460443d51373d407d9fe9636dca356"
    sha256 x86_64_linux:   "8759daf1b29c712194d59ae6d18b1e1df8c633f625e57ab64472ecfd2ae55ddd"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "icu4c"
  depends_on "libpq"
  depends_on "mysql-client@8.0"
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
    ENV["MYSQL_ROOT_DIR"] = Formula["mysql-client@8.0"].opt_prefix.to_s
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