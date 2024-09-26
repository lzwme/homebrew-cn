class Groonga < Formula
  desc "Fulltext search engine and column store"
  homepage "https:groonga.org"
  url "https:github.comgroongagroongareleasesdownloadv14.0.8groonga-14.0.8.tar.gz"
  sha256 "eddcb59c800ea454e3794568666581ecd7122f6120aa523b2b7dd92d8fe2877c"
  license "LGPL-2.1-or-later"

  livecheck do
    url :homepage
    regex(%r{>v?(\d+(?:\.\d+)+)<a> is the latest release}i)
  end

  bottle do
    sha256 arm64_sequoia: "a5a4d15dc67fd831934a4c05b99812a9eedcd9f983fdb75f1a6861024f01c9ca"
    sha256 arm64_sonoma:  "d09300d311d5436e99d424b2a60769ff91abc1b612aae3ea7834a960bfc398f4"
    sha256 arm64_ventura: "85a6f993f828913dca926dfbe401602b618731477e54a502e98dae52bd92b20e"
    sha256 sonoma:        "b4d1c8b8d895031b0eba0622c89b513b65726c6f146a94b8cec348708a25913f"
    sha256 ventura:       "e06b819f43839bcc3ae217898a143687fe6c69bb9d9fa4e34590824028ce4c2b"
    sha256 x86_64_linux:  "2e8ce99b4efdd0c6b424aa3ab2846799f5f77003b81a9a988054f3eaf8d5791e"
  end

  head do
    url "https:github.comgroongagroonga.git", branch: "main"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
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