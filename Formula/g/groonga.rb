class Groonga < Formula
  desc "Fulltext search engine and column store"
  homepage "https://groonga.org/"
  url "https://ghfast.top/https://github.com/groonga/groonga/releases/download/v15.1.3/groonga-15.1.3.tar.gz"
  sha256 "2fc5078d80507fd8800ef22ced035903ff35166558ffe802c12ef77dfeb67587"
  license "LGPL-2.1-or-later"

  livecheck do
    url :homepage
    regex(%r{>v?(\d+(?:\.\d+)+)</a> is the latest release}i)
  end

  bottle do
    sha256 arm64_sequoia: "55108a61b787d1db98999604d003a3fbcedfaaa783c5f245f0bb5b859e1f398c"
    sha256 arm64_sonoma:  "7053b2fc55d6aec4298cf042159b530fce5ad5bcc258d063ea830394db38a3c1"
    sha256 arm64_ventura: "6b8b0fe131279f863738ed07537ee1ffaa1bacaaf74446de52d12f8e5bea1377"
    sha256 sonoma:        "346e2596561348e7aa5bf2d7f3a9383b111063e012faa96b6bf0c7ecb67c025b"
    sha256 ventura:       "aa2256472ea09a47f368e229e3172fe1e6f3dd42d8ea0610ab6ac293b1729666"
    sha256 arm64_linux:   "0f1a5e5cbe03be26908bcfbf8a13f5377b1e5245cceb801dc7c074620ea5f717"
    sha256 x86_64_linux:  "9eb390a48401aa1bc299728f789fca02256c9724cf0b39a85ca968bbd576938c"
  end

  head do
    url "https://github.com/groonga/groonga.git", branch: "main"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkgconf" => :build
  depends_on "mecab"
  depends_on "mecab-ipadic"
  depends_on "msgpack"
  depends_on "openssl@3"

  uses_from_macos "libxcrypt"
  uses_from_macos "zlib"

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