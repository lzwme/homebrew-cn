class Groonga < Formula
  desc "Fulltext search engine and column store"
  homepage "https:groonga.org"
  url "https:github.comgroongagroongareleasesdownloadv15.0.3groonga-15.0.3.tar.gz"
  sha256 "2728f32f73a20a9b4bf500f11f49418c45e2842a04bebaf3dce0d038b452d114"
  license "LGPL-2.1-or-later"

  livecheck do
    url :homepage
    regex(%r{>v?(\d+(?:\.\d+)+)<a> is the latest release}i)
  end

  bottle do
    sha256 arm64_sequoia: "8ab23733350554b441331007067249b36077e78a4d5e578c8a0427fcfac92e54"
    sha256 arm64_sonoma:  "fd420e9e0ddcf808e7d1ee20cd9bcaed174d8e0233ab9ba8d3470a4b0fb4606e"
    sha256 arm64_ventura: "21edfe4e5e7d06b179f86b4f1f366d467aa42fa45c7b8bae26b02fd9e9734a6d"
    sha256 sonoma:        "f9a6fc9c76877cf7d07fa08a3ff3bea7381dd9f5a7dea690e029d796d7e3fa4f"
    sha256 ventura:       "3bfb2db2445906cbb240ee6400449c3f4f6a14a29153e14698b8ed8e2dceb70c"
    sha256 arm64_linux:   "7fd323c6c9c63c6f6a8ef0c6e2ace5f46236bac981a39b62a9554a00e736670a"
    sha256 x86_64_linux:  "a8cd2312c572639f143ed015567a0e494a14a2134267ab8a8c5047395960ec18"
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