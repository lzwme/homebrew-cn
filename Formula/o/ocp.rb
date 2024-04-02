class Ocp < Formula
  desc "UNIX port of the Open Cubic Player"
  homepage "https:stian.cubic.orgproject-ocp.php"
  url "https:stian.cubic.orgocpocp-0.2.108.tar.xz"
  sha256 "d7b983966f6bf7285c1554181edcfdcd2017f9629c41ee38b698a89b65f3b1ea"
  license "GPL-2.0-or-later"
  head "https:github.commywave82opencubicplayer.git", branch: "master"

  livecheck do
    url :homepage
    regex(href=.*?ocp[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 arm64_sonoma:   "7f9f5ed5a7dc88446c8ab99ed61c5bb921ea712ada779e8c060bf8205e15d232"
    sha256 arm64_ventura:  "aac12026c5b04950c1679dcbe9df628e28dd17b5b36bde6c7b335fcda00d3491"
    sha256 arm64_monterey: "e2e503011fcefdda6d2aa7f09ead08397a287878372f053a470d4d032a4fd7c3"
    sha256 sonoma:         "5e07d48f03aa82c0876c439d66ce4151e305316032aa8aacfb09039dbfafe201"
    sha256 ventura:        "7550b0144d37eda1e61fb5270ef7724f3afb3193436840ef3315690b314a4a8f"
    sha256 monterey:       "cbcea5a3789c4a06f7843f45f07e7156ad6b4a9e32d5f4a048836b21a768376c"
    sha256 x86_64_linux:   "b8e56d68116ca183e7240497fc8c074ed41a5f84bc4624cda390d8ca06327881"
  end

  depends_on "pkg-config" => :build
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

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  on_linux do
    depends_on "util-linux" => :build # for `hexdump`
  end

  # pin to 15.0.6 to use precompiled fonts
  resource "unifont" do
    url "https:ftp.gnu.orggnuunifontunifont-15.0.06unifont-15.0.06.tar.gz"
    sha256 "36668eb1326d22e1466b94b3929beeafd10b9838bf3d41f4e5e3b52406ae69f1"
  end

  def install
    ENV.deparallelize

    # Required for SDL2
    resource("unifont").stage do |r|
      cd "fontprecompiled" do
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

    system ".configure", *args
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}ocp", "--help"
  end
end