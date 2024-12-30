class Lanraragi < Formula
  desc "Web application for archival and reading of mangadoujinshi"
  homepage "https:github.comDifegueLANraragi"
  url "https:github.comDifegueLANraragiarchiverefstagsv.0.9.30.tar.gz"
  sha256 "ec3ec61acebaf427e5c8b6873fd477d6aae5b084552ac981112692535ad0fbdf"
  license "MIT"
  head "https:github.comDifegueLANraragi.git", branch: "dev"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "dabd80ac33bd251fb05017964420e48c542095b275f86330c6abe2242dcbac53"
    sha256 cellar: :any,                 arm64_sonoma:  "1ef34ca2ccb4c9f3e317a2d458c1e1b818aa9f3f3e0083d50be001ff47515972"
    sha256 cellar: :any,                 arm64_ventura: "eb632569f52619d1102c01f3d8ac50b12b48d30d6b9a078026242455a6479f4a"
    sha256 cellar: :any,                 sonoma:        "4751aad23f69d0aaa3d02c140bf3468ad6a9b01088165435fcbd4a4638371bf8"
    sha256 cellar: :any,                 ventura:       "87e9fefcf02eb7c04a42811bcb08639d9facc7b727ba13fef0927ce516df137e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ae0d76c2177e8d830c0b6c2729c37130fda9dcb4cffbf4322e1b83b18e3db8c1"
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