class Ocp < Formula
  desc "UNIX port of the Open Cubic Player"
  homepage "https://stian.cubic.org/project-ocp.php"
  url "https://stian.cubic.org/ocp/ocp-3.1.2.tar.xz"
  sha256 "6bfa006bb0177c38fc000fce7e370961b0a7211d359a91c490cbb858afa992d9"
  license "GPL-2.0-or-later"
  head "https://github.com/mywave82/opencubicplayer.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?ocp[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "5da338fd0f53a5e89576345e95b1ac20c6ec736849b2f00a79ec6a864392a524"
    sha256 arm64_sequoia: "cd62d588713208a2d148b7c84d7fa6227cd63f65f7f5e8574789d7ed121404c7"
    sha256 arm64_sonoma:  "c14211b4c0d63e631801c110ae85865a90004fc60e02c9060560071be72bd649"
    sha256 sonoma:        "fe27aeddbc5c7b999c0df4dad888aa704e9055d94e5c52b3909eadd44d918cdd"
    sha256 arm64_linux:   "cab5275b087dbf7cf1dbd26fb121c1588e085bb2d688908916416937cd9ff226"
    sha256 x86_64_linux:  "7455f6ba30f41a856d6e2528ee31fb422d2fb728335c21aab180785327349418"
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
  depends_on "sdl2"

  uses_from_macos "bzip2"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  on_macos do
    depends_on "libogg"
  end

  on_linux do
    depends_on "util-linux" => :build # for `hexdump`
    depends_on "alsa-lib"
  end

  # Fix qoaplay.c:226:5: error: expected expression
  # PR ref: https://github.com/mywave82/opencubicplayer/pull/147
  # pin to 16.0.02 to use precompiled fonts
  # https://github.com/mywave82/opencubicplayer/blob/master/mingw/versionsconf.sh#L20
  resource "unifont" do
    url "https://ftpmirror.gnu.org/gnu/unifont/unifont-16.0.02/unifont-16.0.02.tar.gz"
    sha256 "f128ec8763f2264cd1fa069f3195631c0b1365366a689de07b1cb82387aba52d"
  end

  def install
    # Required for SDL2
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
    system "make"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ocp --help 2>&1")

    assert_path_exists testpath/".config/ocp/ocp.ini"
  end
end