class Lanraragi < Formula
  desc "Web application for archival and reading of mangadoujinshi"
  homepage "https:github.comDifegueLANraragi"
  url "https:github.comDifegueLANraragiarchiverefstagsv.0.9.21.tar.gz"
  sha256 "ed2d704d058389eb4c97d62080c64fa96fcc230be663ec8958f35764d229c463"
  license "MIT"
  head "https:github.comDifegueLANraragi.git", branch: "dev"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "6fae9d6c20a48326cbd9ea44d9d974ab4004af1a2321e1987d7e49d025da4908"
    sha256 cellar: :any,                 arm64_ventura:  "9ee44ada4bdaa609d91dc9f09788a5d3d6ba7b9a5b6766e2ac995e69bab890e9"
    sha256 cellar: :any,                 arm64_monterey: "f4eb81ea0f98d1f4a277bc65322cbc3fa91d953f6de27a53ed9df962d860b83b"
    sha256 cellar: :any,                 sonoma:         "754026306df0ce7a6985955846c193597b78f1fd3063d937d34e6a248d5cbabe"
    sha256 cellar: :any,                 ventura:        "8f81574cb6abb21b30a77e82a2148aa7ac4dcad1138e6594f4e1b7c343ed8cd8"
    sha256 cellar: :any,                 monterey:       "45ae93581953466567ca4d0d6712aa8a9dccc07348967d1fd70e74db2bf42470"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5b19a62ceb6089cd7c1d3772b51fc0b87ffbf42a097a5be272d9cca51dac8497"
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