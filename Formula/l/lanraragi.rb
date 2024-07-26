require "languagenode"

class Lanraragi < Formula
  desc "Web application for archival and reading of mangadoujinshi"
  homepage "https:github.comDifegueLANraragi"
  url "https:github.comDifegueLANraragiarchiverefstagsv.0.9.20.tar.gz"
  sha256 "1687ed39880853f5f5169af3b8deda5e4cda1550720aec823223b46851d74147"
  license "MIT"
  head "https:github.comDifegueLANraragi.git", branch: "dev"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "8995e18a94e7d89a0f39fce755a6a6b555bae0b10a54840067435e24478d7821"
    sha256 cellar: :any,                 arm64_ventura:  "dede1bb7b28346c14c83adc7b6d55bc62ab7f1885c80e1c3462f9e514fb2b933"
    sha256 cellar: :any,                 arm64_monterey: "c482daed03606b2bd8b9c9df9618fd48689c1de496173eee5385365e1ab43034"
    sha256 cellar: :any,                 sonoma:         "0c535a25ca5de8e2c4b40d826361fd7e52aa7ff4632ac13ea0b0f00b7b6b6edf"
    sha256 cellar: :any,                 ventura:        "279850b9e112c04bcdd2adc455cbc20cc4d522f37808e58cfd8c6ab6f0eb5558"
    sha256 cellar: :any,                 monterey:       "40414eaf617fcd0487cf5cce2c70d57f8e1bbaa295961b01a602f11b6ab8bd19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f2209da866d09b8ca582ae8e37dc180aff6f9631a906da3f147a80f072d7bf02"
  end

  depends_on "nettle" => :build
  depends_on "pkg-config" => :build

  depends_on "cpanminus"
  depends_on "ghostscript"
  depends_on "giflib"
  depends_on "imagemagick"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "node"
  depends_on "openssl@3"
  depends_on "perl"
  depends_on "redis"
  depends_on "zstd"

  uses_from_macos "libarchive"
  uses_from_macos "libffi"

  on_macos do
    depends_on "lz4"
  end

  resource "libarchive-headers" do
    on_macos do
      url "https:github.comapple-oss-distributionslibarchivearchiverefstagslibarchive-131.tar.gz"
      sha256 "8d0e4d71d2b039a968d2c7b4230806912785da98ce5d3a10c60024016ac343bb"
    end
  end

  resource "Image::Magick" do
    url "https:cpan.metacpan.orgauthorsidJJCJCRISTYImage-Magick-7.1.1-28.tar.gz"
    sha256 "bc54137346c1d45626e7075015f7d1dae813394af885457499f54878cfc19e0b"
  end

  def install
    ENV.prepend_create_path "PERL5LIB", "#{libexec}libperl5"
    ENV.prepend_path "PERL5LIB", "#{libexec}lib"

    # On Linux, use the headers provided by the libarchive formula rather than the ones provided by Apple.
    ENV["CFLAGS"] = if OS.mac?
      "-I#{libexec}include"
    else
      "-I#{Formula["libarchive"].opt_include}"
    end

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

    if OS.mac?
      resource("libarchive-headers").stage do
        cd "libarchivelibarchive" do
          (libexec"include").install "archive.h", "archive_entry.h"
        end
      end
    end

    system "cpanm", "Config::AutoConf", "--notest", "-l", libexec
    system "npm", "install", *Language::Node.local_npm_install_args
    system "perl", ".toolsinstall.pl", "install-full"

    prefix.install "README.md"
    (libexec"lib").install Dir["lib*"]
    libexec.install "script", "package.json", "public", "templates", "tests", "lrr.conf"
    cd "toolsbuildhomebrew" do
      bin.install "lanraragi"
      libexec.install "redis.conf"
    end
  end

  def caveats
    <<~EOS
      Automatic thumbnail generation will not work properly on macOS < 10.15 due to the bundled Libarchive being too old.
      Opening archives for reading will generate thumbnails normally.
    EOS
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