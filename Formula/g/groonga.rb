class Groonga < Formula
  desc "Fulltext search engine and column store"
  homepage "https:groonga.org"
  url "https:github.comgroongagroongareleasesdownloadv13.0.9groonga-13.0.9.tar.gz"
  sha256 "66678e630addd57bf0aaae7ae733ad703bfa85e38b555685d383358c4b630cef"
  license "LGPL-2.1-or-later"

  livecheck do
    url :homepage
    regex(%r{>v?(\d+(?:\.\d+)+)<a> is the latest release}i)
  end

  bottle do
    sha256 arm64_sonoma:   "0440c0dd4089826d25e04e1e64858e8f5084bcb1d34c4381ce3e02bde2140151"
    sha256 arm64_ventura:  "fab85c5f03f41dedb92d4aed3b52b66bd18887218831cddf01e10b7eade92d9b"
    sha256 arm64_monterey: "e26b75fdb612f8d698bd1674998e377a49da58d1e1feabdb80a8afb7b281eedb"
    sha256 sonoma:         "b5e98c80139aadb6b6611190698b07df9023d74ddb255007d80f3fbebe3e9b0f"
    sha256 ventura:        "3a4f9d0d3ac99aadc7b0eb1a577f12df251fbc04ab1e8bfbc3307f57a36f6250"
    sha256 monterey:       "448e0b0009e4461312574d8d3af6917b123cd83447faa9bc26cba132fede9333"
    sha256 x86_64_linux:   "98c8f52d2bbc7fb7132cb4bc0bbdf7d37d10a56c51c16494be3104aa5ceb7a9c"
  end

  head do
    url "https:github.comgroongagroonga.git", branch: "master"
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