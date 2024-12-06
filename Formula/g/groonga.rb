class Groonga < Formula
  desc "Fulltext search engine and column store"
  homepage "https:groonga.org"
  url "https:github.comgroongagroongareleasesdownloadv14.1.1groonga-14.1.1.tar.gz"
  sha256 "c79c086101fc4fe92c48c2004101d69e997ad63b8d3e575a12ab887eb045d548"
  license "LGPL-2.1-or-later"

  livecheck do
    url :homepage
    regex(%r{>v?(\d+(?:\.\d+)+)<a> is the latest release}i)
  end

  bottle do
    sha256 arm64_sequoia: "9235dd8f3d5ff0e3af5fd5ca283752d2c73ea06e1515608658c0e2565297be87"
    sha256 arm64_sonoma:  "e7cecbf08addc2b73e97fc0a49ba2b7b6b6b3ed925783ed384e4b107392e8ac7"
    sha256 arm64_ventura: "f678cc78b01b2c49e4eefecdc0bb2e3c745800d26bf66bec25c625eb053b482b"
    sha256 sonoma:        "e90debde7b3d483df22d00809b0c1a42e18580d6c0cc64dee2ecb15c0a7b40f6"
    sha256 ventura:       "1d1e1960ac1fb691ce582a7ca256cbeff4dd889148bb0b5f6523912a01d4b335"
    sha256 x86_64_linux:  "84eace016df76eba97038576e8a978e7e19422a5192421c6f0693388d0b95c8c"
  end

  head do
    url "https:github.comgroongagroonga.git", branch: "main"
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

  link_overwrite "libgroongapluginsnormalizers"
  link_overwrite "sharedocgroonga-normalizer-mysql"
  link_overwrite "libpkgconfiggroonga-normalizer-mysql.pc"

  resource "groonga-normalizer-mysql" do
    url "https:packages.groonga.orgsourcegroonga-normalizer-mysqlgroonga-normalizer-mysql-1.2.1.tar.gz"
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

    system ".autogen.sh" if build.head?

    mkdir "builddir" do
      system "..configure", *args, *std_configure_args
      system "make", "install"
    end

    resource("groonga-normalizer-mysql").stage do
      ENV.prepend_path "PATH", bin
      ENV.prepend_path "PKG_CONFIG_PATH", lib"pkgconfig"
      system ".configure", "--prefix=#{prefix}"
      system "make"
      system "make", "install"
    end
  end

  test do
    IO.popen("#{bin}groonga -n #{testpath}test.db", "r+") do |io|
      io.puts("table_create --name TestTable --flags TABLE_HASH_KEY --key_type ShortText")
      sleep 2
      io.puts("shutdown")
      # expected returned result is like this:
      # [[0,1447502555.38667,0.000824928283691406],true]\n
      assert_match(\[\[0,\d+.\d+,\d+.\d+\],true\], io.read)
    end

    IO.popen("#{bin}groonga -n #{testpath}test-normalizer-mysql.db", "r+") do |io|
      io.puts "register normalizersmysql"
      sleep 2
      io.puts("shutdown")
      # expected returned result is like this:
      # [[0,1447502555.38667,0.000824928283691406],true]\n
      assert_match(\[\[0,\d+.\d+,\d+.\d+\],true\], io.read)
    end
  end
end