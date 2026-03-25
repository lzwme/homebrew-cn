class Lanraragi < Formula
  desc "Web application for archival and reading of manga/doujinshi"
  homepage "https://github.com/Difegue/LANraragi"
  url "https://ghfast.top/https://github.com/Difegue/LANraragi/archive/refs/tags/v.0.9.70.tar.gz"
  sha256 "bc89ae47873a35145a0db5a4d93d274b89e7f546deaa396d389fe7975693f7a6"
  license "MIT"
  head "https://github.com/Difegue/LANraragi.git", branch: "dev"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6f6ce14831069a2d17fd22a7138fa073b60ee21331e13bfa340fcdedd0a2dc6b"
    sha256 cellar: :any,                 arm64_sequoia: "4197fd31d6eaf2eec8b074693a305ebb6a1ae8c53752a804ee328384aa700688"
    sha256 cellar: :any,                 arm64_sonoma:  "fbe6f463fc98a9bc2958cc4a088a782f8b779851cc1641bd983d1ad334f9f189"
    sha256 cellar: :any,                 sonoma:        "cf6505419798f0c775f36f0abbf4c55a1656df2ec1a83c8fae0870954d78e5e3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "05c1d365450337a8f86c67a9af3aa3f32f76f8db60cbc11acd3f9ed0932209bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e01c310845b7f2d122105d4233b1986262c68acfa41e52063372414adaf55cbe"
  end

  depends_on "cpanminus" => :build
  depends_on "pkgconf" => :build

  depends_on "ghostscript"
  depends_on "imagemagick"
  depends_on "libarchive"
  depends_on "node"
  depends_on "openssl@3"
  depends_on "perl" # perl >= 5.36.0
  depends_on "redis" # TODO: migrate to `valkey`
  depends_on "zstd"

  uses_from_macos "libffi"

  resource "Image::Magick" do
    url "https://cpan.metacpan.org/authors/id/J/JC/JCRISTY/Image-Magick-7.1.2-3.tar.gz"
    sha256 "dc6ee21aed560d36f36be608909344bd2e25d63ab5d959553401e02f5df28a6b"

    livecheck do
      url :url
      regex(/href=.*?Image-Magick[._-]v?(\d+(?:\.\d+)*(?:-\d+)?)\.t/i)
    end
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"
    ENV["OPENSSL_PREFIX"] = Formula["openssl@3"].opt_prefix
    ENV["ARCHIVE_LIBARCHIVE_LIB_DLL"] = Formula["libarchive"].opt_lib/shared_library("libarchive")
    ENV["ALIEN_INSTALL_TYPE"] = "system"

    imagemagick = Formula["imagemagick"]
    resource("Image::Magick").stage do
      inreplace "Makefile.PL",
                "/usr/local/include/ImageMagick-#{imagemagick.version.major}",
                "#{imagemagick.opt_include}/ImageMagick-#{imagemagick.version.major}"

      system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
      system "make"
      system "make", "install"
    end

    system "cpanm", "Config::AutoConf", "--notest", "-l", libexec
    system "npm", "install", *std_npm_args(prefix: false)
    system "perl", "./tools/install.pl", "install-full"

    # Modify Archive::Libarchive to help find brew `libarchive`. Although environment
    # variables like `ARCHIVE_LIBARCHIVE_LIB_DLL` and `FFI_CHECKLIB_PATH` exist,
    # it is difficult to guarantee every way of running (like `npm start`) uses them.
    inreplace libexec/"lib/perl5/Archive/Libarchive/Lib.pm",
              "$ENV{ARCHIVE_LIBARCHIVE_LIB_DLL}",
              "'#{ENV["ARCHIVE_LIBARCHIVE_LIB_DLL"]}'"

    (libexec/"lib").install Dir["lib/*"]
    libexec.install "script", "package.json", "public", "locales", "templates", "tests", "lrr.conf"
    libexec.install "tools/build/homebrew/redis.conf"
    bin.install "tools/build/homebrew/lanraragi"
  end

  test do
    # Make sure lanraragi writes files to a path allowed by the sandbox
    ENV["LRR_LOG_DIRECTORY"] = ENV["LRR_TEMP_DIRECTORY"] = testpath
    %w[server.pid shinobu.pid minion.pid].each { |file| touch file }

    # Set PERL5LIB as we're not calling the launcher script
    ENV["PERL5LIB"] = libexec/"lib/perl5"

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