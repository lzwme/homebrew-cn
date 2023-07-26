class Groonga < Formula
  desc "Fulltext search engine and column store"
  homepage "https://groonga.org/"
  url "https://ghproxy.com/https://github.com/groonga/groonga/releases/download/v13.0.3/groonga-13.0.3.tar.gz"
  sha256 "7bd7cdbc9044b06907c57e5295451c36d95c3bfc6ace3a55e86edde337f606d4"
  license "LGPL-2.1-or-later"

  livecheck do
    url :homepage
    regex(%r{>v?(\d+(?:\.\d+)+)</a> is the latest release}i)
  end

  bottle do
    sha256 arm64_ventura:  "ac0487b33ad02751bc52960a914ba2755b1a9894bfbe61dd14232fbf12c69128"
    sha256 arm64_monterey: "e90a23a3c9ffe6d6e990ef6cc263a254c678afb7fe02c8fe65cbbdb3f2c510f4"
    sha256 arm64_big_sur:  "c00d043442bc936737b68879776eaa1ddac1cd4f147223cb2a38a6b015a46106"
    sha256 ventura:        "d0cd3d1b3b827de281baa7d92b08c98c53dbf9f4281ed324ea321d5563608fd3"
    sha256 monterey:       "dfbd3c392458ecac5717ef203d5a32c3a29bc44457d77529b5d804aa0bfe3f78"
    sha256 big_sur:        "39f7a9ac0938270b364b28e4875a35e7abd791f5b497d088dc8b9357dd1a0407"
    sha256 x86_64_linux:   "f0d5e1566b6185a16c1cc0cdc65928bd65a0de59d229d07a23a6b6a1ba64f7a4"
  end

  head do
    url "https://github.com/groonga/groonga.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "mecab"
  depends_on "mecab-ipadic"
  depends_on "msgpack"
  depends_on "openssl@3"
  depends_on "pcre"

  uses_from_macos "libxcrypt"

  on_linux do
    depends_on "glib"
  end

  link_overwrite "lib/groonga/plugins/normalizers/"
  link_overwrite "share/doc/groonga-normalizer-mysql/"
  link_overwrite "lib/pkgconfig/groonga-normalizer-mysql.pc"

  resource "groonga-normalizer-mysql" do
    url "https://packages.groonga.org/source/groonga-normalizer-mysql/groonga-normalizer-mysql-1.2.1.tar.gz"
    sha256 "c8d65bfaf45ea56326e4fec24a1e3818fef9652b2ab3a2ad9b528b7a1a00c0cc"
  end

  def install
    args = %w[
      --disable-zeromq
      --disable-apache-arrow
      --with-luajit=no
      --with-ssl
      --with-zlib
      --without-libstemmer
      --with-mecab
    ]

    system "./autogen.sh" if build.head?

    mkdir "builddir" do
      system "../configure", *args, *std_configure_args
      system "make", "install"
    end

    resource("groonga-normalizer-mysql").stage do
      ENV.prepend_path "PATH", bin
      ENV.prepend_path "PKG_CONFIG_PATH", lib/"pkgconfig"
      system "./configure", "--prefix=#{prefix}"
      system "make"
      system "make", "install"
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