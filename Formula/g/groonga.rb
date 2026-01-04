class Groonga < Formula
  desc "Fulltext search engine and column store"
  homepage "https://groonga.org/"
  license "LGPL-2.1-or-later"
  head "https://github.com/groonga/groonga.git", branch: "main"

  stable do
    url "https://ghfast.top/https://github.com/groonga/groonga/releases/download/v15.2.1/groonga-15.2.1.tar.gz"
    sha256 "77d9aa56e33c0986bbec6ddd2ee897aba6c347cff45fce988f2708145e0c9d77"

    # Workaround for missing CMake file. Remove when fixed in release.
    # PR ref: https://github.com/groonga/groonga/pull/2709
    resource "FindGroongalibedit.cmake" do
      url "https://ghfast.top/https://raw.githubusercontent.com/groonga/groonga/refs/tags/v15.2.1/cmake/FindGroongalibedit.cmake"
      sha256 "26319863f76345bff0fbb4cfde5c1c43430a18b1a36cc58bfe7d26d2910e8d34"

      livecheck do
        formula :parent
      end
    end
  end

  livecheck do
    url :homepage
    regex(%r{>v?(\d+(?:\.\d+)+)</a> is the latest release}i)
  end

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "7e677574b1e5f58027a942e95bfdfaf83929b1649b0e6124bf731fdec3ddf95c"
    sha256 arm64_sequoia: "18d2125ac4a6eddcdca35550f582cec3efde710fda909c9da275f222365abdd7"
    sha256 arm64_sonoma:  "880fc3354150cc996293d03a6fe1457908354161c9df347f2b8ecf66dcdea179"
    sha256 sonoma:        "7a67513a26fb0a93c62cfc3e409b0e5207d154f62ea2aa0bc7cae10a435c2dc4"
    sha256 arm64_linux:   "3496071b3581e7d2a3bcc921fae28f52bc43b43c3db123e6265988c397b145a4"
    sha256 x86_64_linux:  "835fe23e517c8169a36f6389cdc88d83e7d95f60edd8ea4bb94bba3c4c861af7"
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
    if build.stable?
      odie "Remove FindGroongalibedit.cmake resource!" if (buildpath/"cmake/FindGroongalibedit.cmake").exist?
      resource("FindGroongalibedit.cmake").stage(buildpath/"cmake")
    end

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