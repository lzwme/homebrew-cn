class Groonga < Formula
  desc "Fulltext search engine and column store"
  homepage "https://groonga.org/"
  url "https://ghfast.top/https://github.com/groonga/groonga/releases/download/v15.2.5/groonga-15.2.5.tar.gz"
  sha256 "bfacfc5d867dc43ad48bef49e5302dd7db2109d67cc22995dc8c5ebc5c3ddd5b"
  license "LGPL-2.1-or-later"
  head "https://github.com/groonga/groonga.git", branch: "main"

  livecheck do
    url :homepage
    regex(%r{>v?(\d+(?:\.\d+)+)</a> is the latest release}i)
  end

  bottle do
    sha256 arm64_tahoe:   "932068c1bdebbb8c0b3333fd11029554ecd45503627154c6d34a21f1906c7f89"
    sha256 arm64_sequoia: "5cc8bf53ef427269856e6a27ea4988db19f7459928adb738adde88148aa7f302"
    sha256 arm64_sonoma:  "422a784186168535946150805f1dd26855e92ea0e1c1b196aa206ee9ef2c8032"
    sha256 sonoma:        "00269e78b806aaad3dd30679a093b8e406da748e79d8e8c1d9ba1a471419798c"
    sha256 arm64_linux:   "140ff77b159b4ac49d1601ed1a6987a4d2c078dadfb9f2fa7811469d0ec0ce09"
    sha256 x86_64_linux:  "a67f074d5ceea9e071efa5269be9eccbfa891ead4af487af36cfbb85c5ce182a"
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
  uses_from_macos "zlib"

  link_overwrite "lib/groonga/plugins/normalizers/"
  link_overwrite "share/doc/groonga-normalizer-mysql/"
  link_overwrite "lib/pkgconfig/groonga-normalizer-mysql.pc"

  resource "groonga-normalizer-mysql" do
    url "https://ghfast.top/https://github.com/groonga/groonga-normalizer-mysql/releases/download/v1.3.0/groonga-normalizer-mysql-1.3.0.tar.gz"
    sha256 "693c24eff9ba95cd498ba28f8d5826843caec347b5aa6976e565e69535b44147"
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