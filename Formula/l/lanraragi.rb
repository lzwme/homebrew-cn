class Lanraragi < Formula
  desc "Web application for archival and reading of mangadoujinshi"
  homepage "https:github.comDifegueLANraragi"
  url "https:github.comDifegueLANraragiarchiverefstagsv.0.9.21.tar.gz"
  sha256 "ed2d704d058389eb4c97d62080c64fa96fcc230be663ec8958f35764d229c463"
  license "MIT"
  revision 3
  head "https:github.comDifegueLANraragi.git", branch: "dev"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4addeef09e330f210354da1d2f0593e88621616320057ba2cdc388f76a447e29"
    sha256 cellar: :any,                 arm64_sonoma:  "3de5bf3ab193cc551e1a843a7ffdf01ef2f28248979079a8b1b390eaa8a052d9"
    sha256 cellar: :any,                 arm64_ventura: "46c910c967b0de95eb0131df3821ca428e91d03c4d0910c6dc1502fc895ffd98"
    sha256 cellar: :any,                 sonoma:        "7eea02846ca205288ab639fe55a41f9fb81598f2f4f111c58b3adb157bf8fae6"
    sha256 cellar: :any,                 ventura:       "6c295cfa1ef859951ed5855f962c6a8249173f6cd180322091646b4bee817126"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "596296f78997c0c66c9cfc01b900ba54782d1500fc2f47ede41c7dc29116b968"
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
    depends_on "libb2"
    depends_on "lz4"
    depends_on "lzo"
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

    return if OS.linux? || Hardware::CPU.intel?

    # FIXME: This installs its own `libarchive`, but we should use our own to begin with.
    #        As a workaround, install symlinks to our `libarchive` instead of the downloaded ones.
    libarchive_install_dir = libexec"libperl5darwin-thread-multi-2levelautosharedistAlien-Libarchive3dynamic"
    libarchive_install_dir.children.map(&:unlink)
    ln_sf Formula["libarchive"].opt_lib.children, libarchive_install_dir
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