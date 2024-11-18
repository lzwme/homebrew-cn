class Lanraragi < Formula
  desc "Web application for archival and reading of mangadoujinshi"
  homepage "https:github.comDifegueLANraragi"
  url "https:github.comDifegueLANraragiarchiverefstagsv.0.9.22.tar.gz"
  sha256 "979b819994fdf4260a19bf276aef407da9c1d9d294bee44fc7a1f600c1ce5696"
  license "MIT"
  head "https:github.comDifegueLANraragi.git", branch: "dev"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "2a7275439b294f72023ac1504a45fb965d53755baf6fd9a9e991e1593a810285"
    sha256 cellar: :any,                 arm64_sonoma:  "b85651e4ab341d8af56a2841123455d929bea02b9bf2894d7ec95436ad7d1811"
    sha256 cellar: :any,                 arm64_ventura: "2e0d1db33e27f99d320e15b07569941e8493de031cac8ae8d7ddb99e1f55c3b2"
    sha256 cellar: :any,                 sonoma:        "67b587ef379adbd02c1a06fc00853e511462d60bf1d44c5994f79d975343e1b6"
    sha256 cellar: :any,                 ventura:       "ea30b9840d34c455744871551cd6c55152e1a9785d28dced8048c75f1c4f1896"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e8df596c32e9240b2457921e8ae84d6d566e202735b0dcf58fe6efd05a169440"
  end

  depends_on "pkgconf" => :build

  depends_on "cpanminus"
  depends_on "ghostscript"
  depends_on "imagemagick"
  depends_on "libarchive"
  depends_on "node"
  depends_on "openssl@3"
  depends_on "perl"
  depends_on "redis" # TODO: migrate to `valkey`
  depends_on "zstd"

  uses_from_macos "libffi"

  resource "Image::Magick" do
    url "https:cpan.metacpan.orgauthorsidJJCJCRISTYImage-Magick-7.1.1-28.tar.gz"
    sha256 "bc54137346c1d45626e7075015f7d1dae813394af885457499f54878cfc19e0b"
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec"libperl5"
    ENV["OPENSSL_PREFIX"] = Formula["openssl@3"].opt_prefix
    ENV["ARCHIVE_LIBARCHIVE_LIB_DLL"] = Formula["libarchive"].opt_libshared_library("libarchive")
    ENV["ALIEN_INSTALL_TYPE"] = "system"

    imagemagick = Formula["imagemagick"]
    resource("Image::Magick").stage do
      inreplace "Makefile.PL",
                "usrlocalincludeImageMagick-#{imagemagick.version.major}",
                "#{imagemagick.opt_include}ImageMagick-#{imagemagick.version.major}"

      system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
      system "make"
      system "make", "install"
    end

    system "cpanm", "Config::AutoConf", "--notest", "-l", libexec
    system "npm", "install", *std_npm_args(prefix: false)
    system "perl", ".toolsinstall.pl", "install-full"

    # Modify Archive::Libarchive to help find brew `libarchive`. Although environment
    # variables like `ARCHIVE_LIBARCHIVE_LIB_DLL` and `FFI_CHECKLIB_PATH` exist,
    # it is difficult to guarantee every way of running (like `npm start`) uses them.
    inreplace libexec"libperl5ArchiveLibarchiveLib.pm",
              "$ENV{ARCHIVE_LIBARCHIVE_LIB_DLL}",
              "'#{ENV["ARCHIVE_LIBARCHIVE_LIB_DLL"]}'"

    (libexec"lib").install Dir["lib*"]
    libexec.install "script", "package.json", "public", "templates", "tests", "lrr.conf"
    libexec.install "toolsbuildhomebrewredis.conf"
    bin.install "toolsbuildhomebrewlanraragi"
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