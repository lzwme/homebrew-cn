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
  revision 3
  version_scheme 1
  head "https:github.commanticoresoftwaremanticoresearch.git", branch: "master"

  # Only even patch versions are stable releases
  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+\.\d*[02468])$i)
  end

  bottle do
    sha256 arm64_sequoia: "92c7e1e0a2460bf6a162cc8b2538b480e4d459e094b012416721f533409fcb41"
    sha256 arm64_sonoma:  "7fca603aa14ede68b1250ee2682fc4f2566bb2dd7cd8e28d19d1bd2af4a0d920"
    sha256 arm64_ventura: "3967ad2018ad828025d507b82c54e77793fdd929858127ebcff047b6fdf95b3e"
    sha256 sonoma:        "a18224ed44c2c3c7fbf3b22dee6a2094ce5bb8872843598d75439a02dddd178d"
    sha256 ventura:       "075d222eb10a8267ce03cfa1db387fd87e7b75894ff2b5d028ff00d839c986e5"
    sha256 x86_64_linux:  "9d015d69fc39acb3abf55b7502b7d89a29ab1f288a9c8b3aef3c117ae96882a3"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "nlohmann-json" => :build
  depends_on "snowball" => :build # for libstemmer.a

  # NOTE: `libpq`, `mariadb-connector-c`, `unixodbc` and `zstd` are dynamically loaded rather than linked
  depends_on "cctz"
  depends_on "icu4c@76"
  depends_on "libpq"
  depends_on "mariadb-connector-c"
  depends_on "openssl@3"
  depends_on "re2"
  depends_on "unixodbc"
  depends_on "xxhash"
  depends_on "zstd"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "expat"
  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  def install
    # Work around error when building with GCC
    # Issue ref: https:github.commanticoresoftwaremanticoresearchissues2393
    ENV.append_to_cflags "-fpermissive" if OS.linux?

    ENV["ICU_ROOT"] = deps.find { |dep| dep.name.match?(^icu4c(@\d+)?$) }
                          .to_formula.opt_prefix.to_s
    ENV["OPENSSL_ROOT_DIR"] = Formula["openssl@3"].opt_prefix.to_s
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
      -DMYSQL_CONFIG_EXECUTABLE=#{Formula["mariadb-connector-c"].opt_bin}mariadb_config
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