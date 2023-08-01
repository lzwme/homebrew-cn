class Ocp < Formula
  desc "UNIX port of the Open Cubic Player"
  homepage "https://stian.cubic.org/project-ocp.php"
  url "https://stian.cubic.org/ocp/ocp-0.2.106.tar.xz"
  sha256 "bf11d96d4a58bbf9c344eb53cf815fc2097c63a3c2c713f7ffb134073bd84721"
  license "GPL-2.0-or-later"
  head "https://github.com/mywave82/opencubicplayer.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?ocp[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "6370f8dcd5be6d7e6bc439a0367da6545722c012035a645da7ec4e6e660fd4d0"
    sha256 arm64_monterey: "47fb624efc62c195eef2cfefbc339e9488a4c68387176d2ace28077060546845"
    sha256 arm64_big_sur:  "56fdb440186f94635e2bc6a83353967e27cc6563a47ea0ee6f82b47ed3bc2a13"
    sha256 ventura:        "500b78981dea43442b0fa4c9c7ac006b1211cd1ea7bc2d1f7dc6de36d467ad48"
    sha256 monterey:       "5dbc87f6a3610a4e5999a44322a73b2cd5135bbecca6e527c317f478ab3970e3"
    sha256 big_sur:        "92223048921e594a0e05b1a1addf487df4ca6a962fc8642dc6687ff909184b1e"
    sha256 x86_64_linux:   "4783cdb910e8ec9be952dc0f1a6d64a82411591b71ee2b70e52a2771c2b1aadf"
  end

  depends_on "pkg-config" => :build
  depends_on "xa" => :build
  depends_on "ancient"
  depends_on "cjson"
  depends_on "flac"
  depends_on "freetype"
  depends_on "jpeg-turbo"
  depends_on "libdiscid"
  depends_on "libpng"
  depends_on "libvorbis"
  depends_on "mad"
  depends_on "sdl2"

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  on_linux do
    depends_on "util-linux" => :build # for `hexdump`
  end

  resource "unifont" do
    url "https://ftp.gnu.org/gnu/unifont/unifont-15.0.06/unifont-15.0.06.tar.gz"
    sha256 "36668eb1326d22e1466b94b3929beeafd10b9838bf3d41f4e5e3b52406ae69f1"
  end

  # patch for clockid_t redefinition issue
  patch do
    url "https://github.com/mywave82/opencubicplayer/commit/6ad481d04cf34f29755b12aac9e9e3c046cfe764.patch?full_index=1"
    sha256 "85943335fe93e577ef42c427f32b9a3759ec52beed86930e289205b2f5a30d1a"
  end

  def install
    ENV.deparallelize

    # Required for SDL2
    resource("unifont").stage do |r|
      cd "font/precompiled" do
        share.install "unifont-#{r.version}.ttf" => "unifont.ttf"
        share.install "unifont_csur-#{r.version}.ttf" => "unifont_csur.ttf"
        share.install "unifont_upper-#{r.version}.ttf" => "unifont_upper.ttf"
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

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/ocp", "--help"
  end
end