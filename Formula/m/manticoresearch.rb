class Manticoresearch < Formula
  desc "Open source text search engine"
  homepage "https:manticoresearch.com"
  url "https:github.commanticoresoftwaremanticoresearcharchiverefstags6.3.6.tar.gz"
  sha256 "d0409bde33f4fe89358ad7dbbad775e1499d4e61fed16d4fa84f9b29b89482d2"
  license all_of: [
    "GPL-3.0-or-later",
    "GPL-2.0-only", # wsrep
    { "GPL-2.0-only" => { with: "x11vnc-openssl-exception" } }, # galera
    { any_of: ["Unlicense", "MIT"] }, # uni-algo (our formula is too new)
  ]
  revision 2
  version_scheme 1
  head "https:github.commanticoresoftwaremanticoresearch.git", branch: "master"

  # Only even patch versions are stable releases
  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+\.\d*[02468])$i)
  end

  bottle do
    sha256 arm64_sequoia: "b39705310475810e2b1b36ad2eb2a286d5a46f50005a643cb50b3729d979a58c"
    sha256 arm64_sonoma:  "b1cf94ca6ad851b9bfcaa32014f7eb363d5de286226c280b74484d9754b77a42"
    sha256 arm64_ventura: "27cce8ac45d7c3ac64d530f2223ff2aec3e7c845e53e73a0f9e833eed2c2d048"
    sha256 sonoma:        "c7f0b07f128ae82e8100c29a05819ac0c2efd87d1941f46383305bf63e5e57b1"
    sha256 ventura:       "01239133f7b0b84f4e2407712e48cfcc40c71e0729ba466b6945c741d56f788c"
    sha256 x86_64_linux:  "e87aa1d3877a44aebcf61eab5c8f4a6542b36e7d8e3d8c5ed769b99c613ec87f"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "nlohmann-json" => :build
  depends_on "snowball" => :build # for libstemmer.a

  # NOTE: `libpq`, `mysql-client`, `unixodbc` and `zstd` are dynamically loaded rather than linked
  depends_on "cctz"
  depends_on "icu4c@76"
  depends_on "libpq"
  depends_on "mysql-client"
  depends_on "openssl@3"
  depends_on "re2"
  depends_on "unixodbc"
  depends_on "xxhash"
  depends_on "zlib" # due to `mysql-client`
  depends_on "zstd"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "libxml2"

  fails_with gcc: "5"

  def install
    # Work around error when building with GCC
    # Issue ref: https:github.commanticoresoftwaremanticoresearchissues2393
    ENV.append_to_cflags "-fpermissive" if OS.linux?

    icu4c = deps.map(&:to_formula).find { |f| f.name.match?(^icu4c@\d+$) }
    ENV["ICU_ROOT"] = icu4c.opt_prefix.to_s
    ENV["OPENSSL_ROOT_DIR"] = Formula["openssl@3"].opt_prefix.to_s
    ENV["MYSQL_ROOT_DIR"] = Formula["mysql-client"].opt_prefix.to_s
    ENV["PostgreSQL_ROOT"] = Formula["libpq"].opt_prefix.to_s

    args = %W[
      -DDISTR_BUILD=homebrew
      -DCMAKE_INSTALL_LOCALSTATEDIR=#{var}
      -DCMAKE_INSTALL_SYSCONFDIR=#{etc}
      -DCMAKE_REQUIRE_FIND_PACKAGE_ICU=ON
      -DCMAKE_REQUIRE_FIND_PACKAGE_cctz=ON
      -DCMAKE_REQUIRE_FIND_PACKAGE_nlohmann_json=ON
      -DCMAKE_REQUIRE_FIND_PACKAGE_re2=ON
      -DCMAKE_REQUIRE_FIND_PACKAGE_stemmer=ON
      -DCMAKE_REQUIRE_FIND_PACKAGE_xxHash=ON
      -DRE2_LIBRARY=#{Formula["re2"].opt_libshared_library("libre2")}
      -DWITH_ICU_FORCE_STATIC=OFF
      -DWITH_RE2_FORCE_STATIC=OFF
      -DWITH_STEMMER_FORCE_STATIC=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
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
    pid = spawn(bin"searchd")
  ensure
    Process.kill(9, pid)
    Process.wait(pid)
  end
end