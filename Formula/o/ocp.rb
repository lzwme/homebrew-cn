class Ocp < Formula
  desc "UNIX port of the Open Cubic Player"
  homepage "https://stian.cubic.org/project-ocp.php"
  url "https://stian.cubic.org/ocp/ocp-3.4.1.tar.xz"
  sha256 "dfa4f63eb67536373c7eb1e8cd8b71d78b871d9d41a96e6bb1e4c131144c23f7"
  license "GPL-2.0-or-later"
  head "https://github.com/mywave82/opencubicplayer.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?ocp[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "366b1fbb57f6941fbd5d5ada922489c02cbec5e7547162dc04963f587718014b"
    sha256 arm64_sequoia: "b7798be42d1077853a828d60828a10c1b51f1463b0ff592cf9aef2419dd9a76e"
    sha256 arm64_sonoma:  "1676c20721c3721d21ee3da31e8c2d5c80de5ef2983e5173e1e7017ba5a9f959"
    sha256 sonoma:        "a14d290f7b7db175310f61f07551d32e212da9f8e3b7b7941a20727c8308ba99"
    sha256 arm64_linux:   "13f6f092d454efddd68813da1d4876366d788441130985507b11e7ec04548f1d"
    sha256 x86_64_linux:  "fbf4a6e4d780a134cc66647e87d205622a1b0333dee7c427082c08cf346d6e83"
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

  resource "unifont" do
    url "https://ftpmirror.gnu.org/gnu/unifont/unifont-17.0.05/unifont-17.0.05.tar.gz"
    sha256 "f287cffb26e22723aa36e6684869b0f3ff3bfb822c4b01008bd847911ec1b631"

    livecheck do
      url "https://ghfast.top/https://raw.githubusercontent.com/mywave82/opencubicplayer/refs/heads/master/mingw/versionsconf.sh"
      regex(/^UNIFONT_VERSION="(\d+(?:\.\d+)+)"$/i)
    end
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