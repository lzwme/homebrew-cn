class Groonga < Formula
  desc "Fulltext search engine and column store"
  homepage "https://groonga.org/"
  url "https://ghproxy.com/https://github.com/groonga/groonga/releases/download/v13.0.4/groonga-13.0.4.tar.gz"
  sha256 "38687ab060001aeabe0c0e05de5b90289543eeb98504fdde53c682e937a3d077"
  license "LGPL-2.1-or-later"

  livecheck do
    url :homepage
    regex(%r{>v?(\d+(?:\.\d+)+)</a> is the latest release}i)
  end

  bottle do
    sha256 arm64_ventura:  "bca75923fa9fa35efec47d24c74a1b9a93cb1816960ed4ed3537ac73fbdb4f31"
    sha256 arm64_monterey: "a664ecba4fc0a5edcc729c14f6cd5b157d6b0f7b48e3451cd88b93a7e34bce38"
    sha256 arm64_big_sur:  "23f0f3a45a687251f5584bf05498e8e7e06efe05450a0e3ee8baad164c3d59fd"
    sha256 ventura:        "7df6af58064e6f66cca74d19c6dce039877c4bac7785e6c25745793e721b6553"
    sha256 monterey:       "d81be17ee937b5a1c1a5fc9fe8e22fbe47726c0a93c81198a452bcf5bc396b9f"
    sha256 big_sur:        "e11b2766537cc0d008b8651f01b795521e359e1b37646b0e0038d4336b948470"
    sha256 x86_64_linux:   "262da9bf93061a5bdb108fda4a85d6feda0250cd725da808196e1d35008561a1"
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