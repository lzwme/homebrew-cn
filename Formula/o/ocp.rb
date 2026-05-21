class Ocp < Formula
  desc "UNIX port of the Open Cubic Player"
  homepage "https://stian.cubic.org/project-ocp.php"
  url "https://stian.cubic.org/ocp/ocp-3.3.0.tar.xz"
  sha256 "e3436e2520d6358f3cb9836a78e1da97189ee709f21c714ba8356520dee5265a"
  license "GPL-2.0-or-later"
  head "https://github.com/mywave82/opencubicplayer.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?ocp[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "9d365318e06c48523b98ca49ea5133987deea0041e3aeabf986e7858615f9d56"
    sha256 arm64_sequoia: "3170674e43fc17daa67a5b4a1ded74f5676c07d3c38d574e84566edde97966a9"
    sha256 arm64_sonoma:  "927266f1b78ba17101c376db05a69fee6c9c7a0aa11eb25114e91f7ddb68f86e"
    sha256 sonoma:        "b308c3db7960902dea5df870749478d9bb3960d988431f75c9042261ac4eb000"
    sha256 arm64_linux:   "aeb3027f4c99e4d010c1b0698c52fd68c702564c008c1839e76009f8c598b989"
    sha256 x86_64_linux:  "a5df4490efe85e5aa321758400c58cb77bf92eaf8f0a8d1ded6ed0aa36e0ea81"
  end

  depends_on "pkgconf" => :build
  depends_on "xa" => :build

  depends_on "ancient"
  depends_on "cjson"
  depends_on "flac"
  depends_on "freetype"
  depends_on "game-music-emu"
  depends_on "jpeg-turbo"
  depends_on "libdiscid"
  depends_on "libpng"
  depends_on "libvorbis"
  depends_on "mad"
  depends_on "sdl3"

  uses_from_macos "bzip2"
  uses_from_macos "ncurses"

  on_macos do
    depends_on "libogg"
  end

  on_linux do
    depends_on "util-linux" => :build # for `hexdump`
    depends_on "alsa-lib"
    depends_on "zlib-ng-compat"
  end

  # https://github.com/mywave82/opencubicplayer/blob/master/mingw/versionsconf.sh#L20
  resource "unifont" do
    url "https://ftpmirror.gnu.org/gnu/unifont/unifont-17.0.03/unifont-17.0.03.tar.gz"
    sha256 "9a26aa9adfa8eb1f91b0cd9b83e7f95ea9e14c6e85be71aa3ab0df5cb4e69c35"
  end

  def install
    # Required for SDL3
    resource("unifont").stage do |r|
      cd "font/precompiled" do
        share.install "unifont-#{r.version}.otf" => "unifont.otf"
        share.install "unifont_csur-#{r.version}.otf" => "unifont_csur.otf"
        share.install "unifont_upper-#{r.version}.otf" => "unifont_upper.otf"
      end
    end

    args = %W[
      --prefix=#{prefix}
      --without-x11
      --without-desktop_file_install
      --without-update-mime-database
      --without-update-desktop-database
      --with-unifontdir-ttf=#{share}
      --with-unifontdir-otf=#{share}
    ]

    # We do not use *std_configure_args here since
    # `--prefix` is the only recognized option we pass
    system "./configure", *args
    ENV.deparallelize
    system "make"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ocp --help 2>&1")

    assert_path_exists testpath/".config/ocp/ocp.ini"
  end
end