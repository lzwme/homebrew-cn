class Groonga < Formula
  desc "Fulltext search engine and column store"
  homepage "https:groonga.org"
  url "https:github.comgroongagroongareleasesdownloadv14.0.7groonga-14.0.7.tar.gz"
  sha256 "97428e49adb3542cbc0545279b66c53fcd825176be5f231feba8951096ce4095"
  license "LGPL-2.1-or-later"

  livecheck do
    url :homepage
    regex(%r{>v?(\d+(?:\.\d+)+)<a> is the latest release}i)
  end

  bottle do
    sha256 arm64_sequoia:  "87a527ab33e7e801b267a47e9d3309a6078cdae410c50b983e8a78198a6a94e1"
    sha256 arm64_sonoma:   "1939364b135a0ceddca4d16d07544c1dba11e2153994915bd3ab9ae07c445197"
    sha256 arm64_ventura:  "124dd63c68b9038c3bf4d16eb336a5ad7ba829bdf5b6998cf590eb72eae53cdf"
    sha256 arm64_monterey: "45c38aff0067a6ce9a0725d62feab3bf381f2614e7a8e980b865992264ea8f5a"
    sha256 sonoma:         "76f8a668729df1d6a37ada70f335f229f42a932793197871cbc5a212c6742d65"
    sha256 ventura:        "24b5bd40c496195e11646ed8a339b3b56d60a110e6e549d82d1c2be978be4965"
    sha256 monterey:       "f4f31ae7a7f4e26d9ef29d881589957a6254c54b89584476163aa4e68e89beff"
    sha256 x86_64_linux:   "13602a74b5529f8e02fe4ecd112bc48f06fd23c6b12eb8a665dd7e79daa4fe3b"
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