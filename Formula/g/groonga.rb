class Groonga < Formula
  desc "Fulltext search engine and column store"
  homepage "https://groonga.org/"
  url "https://ghfast.top/https://github.com/groonga/groonga/releases/download/v15.1.4/groonga-15.1.4.tar.gz"
  sha256 "c39afb1e24d0d5864d7634e8dec0e5d2cfbecf43379805ed3a3656c6b3216a19"
  license "LGPL-2.1-or-later"

  livecheck do
    url :homepage
    regex(%r{>v?(\d+(?:\.\d+)+)</a> is the latest release}i)
  end

  bottle do
    sha256 arm64_sequoia: "19162586f1309fb0a826b245f1936f4e8404c772184decf94319a3be7ead7d05"
    sha256 arm64_sonoma:  "024015f299f4eb1dcd5d9ccd97ece92a053e1f2c29e385b8893e14e25d86f600"
    sha256 arm64_ventura: "823ceb350bf9bf9007ec4a277fb11d98bec21a64518f1492c7da8e0d6ab7167d"
    sha256 sonoma:        "966ec68606dd5e7cc6e4124e010ba30f1a1d545add39e3ce9a84830b5db7848b"
    sha256 ventura:       "cb001e14c73e2f25692822d18bd940e853bbb013018a19bf9870d2b4a260abe6"
    sha256 arm64_linux:   "1cd114ba188ea337013944556a1752ffde8d8ef99a2984cc05ae5e023c5ccec3"
    sha256 x86_64_linux:  "626688e0846064f19337f1b8ef5e9a4d194709d8a93301d28432321edacbde09"
  end

  head do
    url "https://github.com/groonga/groonga.git", branch: "main"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "cmake" => :build
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
    url "https://ghfast.top/https://github.com/groonga/groonga-normalizer-mysql/releases/download/v1.2.6/groonga-normalizer-mysql-1.2.6.tar.gz"
    sha256 "f85b49d24f4f4559cb1c0479dcb945a6fa0571390f40aeff38bff8e8f5e84157"
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
      system "cmake", "-S", ".", "-B", "_build", *std_cmake_args
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