class Groonga < Formula
  desc "Fulltext search engine and column store"
  homepage "https://groonga.org/"
  url "https://ghfast.top/https://github.com/groonga/groonga/releases/download/v16.0.1/groonga-16.0.1.tar.gz"
  sha256 "d7c5c2fdd9f3734c00392e3da7c7dbbd9b28e3801f965458ba79c72e7ae581e1"
  license "LGPL-2.1-or-later"
  compatibility_version 1
  head "https://github.com/groonga/groonga.git", branch: "main"

  livecheck do
    url :homepage
    regex(%r{>v?(\d+(?:\.\d+)+)</a> is the latest release}i)
  end

  bottle do
    sha256 arm64_tahoe:   "7f9de82cf2e98da2c3dc0ec360ae085f540cdc9cb80500a402f01b53762c7544"
    sha256 arm64_sequoia: "9607cf440b29afb7f529b7cb8471b21790e62ebc160d8421332ec2842dd4c136"
    sha256 arm64_sonoma:  "f14c347742dfc33000a3b05f6ce1c78aa173e0e885c45cfad4ff1cc021667ca1"
    sha256 sonoma:        "a8f55e2ca7255dd1e9cae174922177404c356f1594972411d9d318469a2d8601"
    sha256 arm64_linux:   "c23578067b4906f747ee6025124aac112fb9378c7ec1455d3bc4b8e74043ef91"
    sha256 x86_64_linux:  "67d5496af2e71e7767879fab5066c5d8d7c4143da480689600c1717825040337"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "lz4"
  depends_on "mecab"
  depends_on "mecab-ipadic" => :no_linkage
  depends_on "msgpack"
  depends_on "onigmo"
  depends_on "simdjson"
  depends_on "zstd"

  uses_from_macos "libedit"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  link_overwrite "lib/groonga/plugins/normalizers/"
  link_overwrite "share/doc/groonga-normalizer-mysql/"
  link_overwrite "lib/pkgconfig/groonga-normalizer-mysql.pc"

  resource "groonga-normalizer-mysql" do
    url "https://ghfast.top/https://github.com/groonga/groonga-normalizer-mysql/releases/download/v1.3.0/groonga-normalizer-mysql-1.3.0.tar.gz"
    sha256 "693c24eff9ba95cd498ba28f8d5826843caec347b5aa6976e565e69535b44147"

    livecheck do
      url :url
    end
  end

  def install
    # Removed bundled libraries but keep files needed by build scripts even when unused
    rm_r(Dir["vendor/*"] - ["vendor/CMakeLists.txt", "vendor/mecab", "vendor/mruby", "vendor/plugins"])

    # Explicitly disable features to avoid opportunistic linkage from superenv CMAKE_PREFIX_PATH.
    # Also set FETCHCONTENT_FULLY_DISCONNECTED=ON to avoid fallback to fetching bundled copies.
    args = %W[
      -DCMAKE_INSTALL_LOCALSTATEDIR=#{var}
      -DCMAKE_INSTALL_RPATH=#{rpath};#{rpath(source: lib/"groonga/plugins/functions")}
      -DCMAKE_INSTALL_SYSCONFDIR=#{etc}
      -DFETCHCONTENT_FULLY_DISCONNECTED=ON
      -DGRN_WITH_BASE64=no
      -DGRN_WITH_BUNDLED_ONIGMO=OFF
      -DGRN_WITH_CURL=no
      -DGRN_WITH_FAISS=no
      -DGRN_WITH_H3=no
      -DGRN_WITH_KYTEA=no
      -DGRN_WITH_LIBEDIT=system
      -DGRN_WITH_LLAMA_CPP=no
      -DGRN_WITH_LIBSTEMMER=no
      -DGRN_WITH_LZ4=system
      -DGRN_WITH_MECAB=yes
      -DGRN_WITH_MESSAGE_PACK=system
      -DGRN_WITH_SIMDJSON=system
      -DGRN_WITH_XSIMD=no
      -DGRN_WITH_XXHASH=no
      -DGRN_WITH_ZEROMQ=no
      -DGRN_WITH_ZLIB=yes
      -DGRN_WITH_ZSTD=system
      -DGroongalz4_FIND_QUIETLY=ON
    ]

    system "cmake", "-S", ".", "-B", "_build", *args, *std_cmake_args
    system "cmake", "--build", "_build"
    system "cmake", "--install", "_build"

    resource("groonga-normalizer-mysql").stage do
      args = ["-DCMAKE_INSTALL_RPATH=#{rpath(source: lib/"groonga/plugins/normalizers")}"]

      system "cmake", "-S", ".", "-B", "_build", *args, *std_cmake_args
      system "cmake", "--build", "_build"
      system "cmake", "--install", "_build"
    end
  end

  test do
    IO.popen("#{bin}/groonga -n #{testpath}/test.db", "r+") do |io|
      io.puts("table_create --name TestTable --flags TABLE_HASH_KEY --key_type ShortText")
      sleep 2
      io.puts("shutdown")
      # expected returned result is like this:
      # [[0,1447502555.38667,0.000824928283691406],true]\n
      assert_match(/\[\[0,\d+.\d+,\d+.\d+\],true\]/, io.read)
    end

    IO.popen("#{bin}/groonga -n #{testpath}/test-normalizer-mysql.db", "r+") do |io|
      io.puts "register normalizers/mysql"
      sleep 2
      io.puts("shutdown")
      # expected returned result is like this:
      # [[0,1447502555.38667,0.000824928283691406],true]\n
      assert_match(/\[\[0,\d+.\d+,\d+.\d+\],true\]/, io.read)
    end
  end
end