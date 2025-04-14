class Manticoresearch < Formula
  desc "Open source text search engine"
  homepage "https:manticoresearch.com"
  url "https:github.commanticoresoftwaremanticoresearcharchiverefstags9.2.24.tar.gz"
  sha256 "46df013f37ac820cafd2257fc53bbcc0a6c1743e590bbf3c78e598780e0dd21b"
  license all_of: [
    "GPL-3.0-or-later",
    "GPL-2.0-only", # wsrep
    { "GPL-2.0-only" => { with: "x11vnc-openssl-exception" } }, # galera
    { any_of: ["Unlicense", "MIT"] }, # uni-algo (our formula is too new)
  ]
  revision 1
  version_scheme 1
  head "https:github.commanticoresoftwaremanticoresearch.git", branch: "master"

  # Only even patch versions are stable releases
  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+\.\d*[02468])$i)
  end

  bottle do
    sha256 arm64_sequoia: "5fdb72f48510a5194310ec60871411a092a5a74e676f9a45d9fdb2c9704e67fa"
    sha256 arm64_sonoma:  "eb6c1d5249ae9d29324f547084d3831b7aad9ee27a9fcc75f2b3b4fdd35c66ff"
    sha256 arm64_ventura: "34737f150e3ab6aca7b567d87ccc2adf2cf35d2a1d42974773779b2b2e011c11"
    sha256 sonoma:        "746e19ca6479b9e29418649faeb22a391a0a0170cc6fa02e610dbe0cb48d41b2"
    sha256 ventura:       "644e02cff9a97b1f50323109083fe82c602252319bd685058294f5d7a503be50"
    sha256 arm64_linux:   "d94a19b007ed35c69453a97df5949b82f2e96e78ef1ebda3ff268a19646547fc"
    sha256 x86_64_linux:  "9be2a1c5ba2d6d2e868ca422c42d73211b1a86b5a4a9b63bcd49b2f203b5e13b"
  end

  depends_on "cmake" => :build
  depends_on "nlohmann-json" => :build
  depends_on "snowball" => :build # for libstemmer.a

  # NOTE: `libpq`, `mariadb-connector-c`, `unixodbc` and `zstd` are dynamically loaded rather than linked
  depends_on "boost"
  depends_on "cctz"
  depends_on "icu4c@77"
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
    # Avoid statically linking to boost
    inreplace "srcCMakeLists.txt", "set ( Boost_USE_STATIC_LIBS ON )", "set ( Boost_USE_STATIC_LIBS OFF )"

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