class Lanraragi < Formula
  desc "Web application for archival and reading of mangadoujinshi"
  homepage "https:github.comDifegueLANraragi"
  url "https:github.comDifegueLANraragiarchiverefstagsv.0.9.21.tar.gz"
  sha256 "ed2d704d058389eb4c97d62080c64fa96fcc230be663ec8958f35764d229c463"
  license "MIT"
  revision 1
  head "https:github.comDifegueLANraragi.git", branch: "dev"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "46e9aa410d112c875d72aa56baf02b97f46d9796c75b417972c3859774314da1"
    sha256 cellar: :any,                 arm64_sonoma:  "703fb53e9661129e560d1e98e66a225a99f1fc9dc0c1235add8e5396a1830e41"
    sha256 cellar: :any,                 arm64_ventura: "3b465015d1bf91080ff26eedfe3781aa2d15b1307895491a35b79989e719da1c"
    sha256 cellar: :any,                 sonoma:        "03ba3bdaf084a6366412bb6b4834316e8bc76cab648241e065b855861eaebe53"
    sha256 cellar: :any,                 ventura:       "e5aef0d44c01143352cbaf61f74b55e497e7b786f222a2e9fd76db829acaa75e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f77b07b914a4282f3ec55cbf198be970d6ce81777f718b088e2bfd7fffc54792"
  end

  depends_on "nettle" => :build
  depends_on "pkg-config" => :build

  depends_on "cpanminus"
  depends_on "ghostscript"
  depends_on "giflib"
  depends_on "imagemagick"
  depends_on "jpeg-turbo"
  depends_on "libarchive"
  depends_on "libpng"
  depends_on "node"
  depends_on "openssl@3"
  depends_on "perl"
  depends_on "redis"
  depends_on "zstd"

  uses_from_macos "libffi"

  on_macos do
    depends_on "lz4"
  end

  resource "Image::Magick" do
    url "https:cpan.metacpan.orgauthorsidJJCJCRISTYImage-Magick-7.1.1-28.tar.gz"
    sha256 "bc54137346c1d45626e7075015f7d1dae813394af885457499f54878cfc19e0b"
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec"libperl5"
    ENV.prepend_path "PERL5LIB", libexec"lib"
    ENV.append_to_cflags "-I#{Formula["libarchive"].opt_include}"
    ENV["OPENSSL_PREFIX"] = Formula["openssl@3"].opt_prefix

    imagemagick = Formula["imagemagick"]
    resource("Image::Magick").stage do
      inreplace "Makefile.PL" do |s|
        s.gsub! "usrlocalincludeImageMagick-#{imagemagick.version.major}",
                "#{imagemagick.opt_include}ImageMagick-#{imagemagick.version.major}"
      end

      system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
      system "make"
      system "make", "install"
    end

    system "cpanm", "Config::AutoConf", "--notest", "-l", libexec
    system "npm", "install", *std_npm_args(prefix: false)
    system "perl", ".toolsinstall.pl", "install-full"

    prefix.install "README.md"
    (libexec"lib").install Dir["lib*"]
    libexec.install "script", "package.json", "public", "templates", "tests", "lrr.conf"
    cd "toolsbuildhomebrew" do
      bin.install "lanraragi"
      libexec.install "redis.conf"
    end
  end

  test do
    # Make sure lanraragi writes files to a path allowed by the sandbox
    ENV["LRR_LOG_DIRECTORY"] = ENV["LRR_TEMP_DIRECTORY"] = testpath
    %w[server.pid shinobu.pid minion.pid].each { |file| touch file }

    # Set PERL5LIB as we're not calling the launcher script
    ENV["PERL5LIB"] = libexec"libperl5"

    # This can't have its _user-facing_ functionality tested in the `brew test`
    # environment because it needs Redis. It fails spectacularly tho with some
    # table flip emoji. So let's use those to confirm _some_ functionality.
    output = <<~EOS
      ｷﾀ━━━━━━(ﾟ∀ﾟ)━━━━━━!!!!!
      (╯・_>・）╯︵ ┻━┻
      It appears your Redis database is currently not running.
      The program will cease functioning now.
    EOS
    # Execute through npm to avoid starting a redis-server
    return_value = OS.mac? ? 61 : 111
    assert_match output, shell_output("npm start --prefix #{libexec}", return_value)
  end
end