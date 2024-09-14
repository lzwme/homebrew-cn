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
  version_scheme 1
  head "https:github.commanticoresoftwaremanticoresearch.git", branch: "master"

  # Only even patch versions are stable releases
  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+\.\d*[02468])$i)
  end

  bottle do
    sha256 arm64_sequoia:  "d1cc0bf982a31827707598ebfca997641504ff4807402ce3fefb7249e9898cb1"
    sha256 arm64_sonoma:   "e8c8da051f17ed8e3984e7a73b2956fe9dbb15af20f6586f7c639b82871d8b76"
    sha256 arm64_ventura:  "7af52d4fa6beb2a7fe7a7fab57d7781c50f340e1c4f164668e03ca543ffc36ba"
    sha256 arm64_monterey: "f793c0bb62386e8cc63f9657788d587c06dc742b507ac3c28d1d828d7ad00c8e"
    sha256 sonoma:         "6f42e036fa7fe8fa7b5e3da02e0c4e0c685c862e0a332d7329aa14d75264007a"
    sha256 ventura:        "ed97b55541841ab96bec286202cbc13bd6e4b3768f82ad18b4a207d2f4d631c9"
    sha256 monterey:       "be12886881943aa6c44fe6f6506322f08163f129e4c91fcb4d3db9a8045bee9c"
    sha256 x86_64_linux:   "5ddaec2c620e960e04733e79738758b88ecdafa09284c11283561005c3cb2449"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "nlohmann-json" => :build
  depends_on "snowball" => :build # for libstemmer.a

  # NOTE: `libpq`, `mysql-client`, `unixodbc` and `zstd` are dynamically loaded rather than linked
  depends_on "cctz"
  depends_on "icu4c"
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

    ENV["ICU_ROOT"] = Formula["icu4c"].opt_prefix.to_s
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