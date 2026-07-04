class Rtorrent < Formula
  desc "Ncurses BitTorrent client based on libtorrent-rakshasa"
  homepage "https://github.com/rakshasa/rtorrent"
  url "https://ghfast.top/https://github.com/rakshasa/rtorrent/releases/download/v0.16.16/rtorrent-0.16.16.tar.gz"
  sha256 "484a128247b81bae6260062113db7afb5ac088b9480cc1690e703c0ce8836847"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "8cb162f411e393168f04eb5118236ff34dd0ee95657d823c9137def59b48884e"
    sha256 cellar: :any, arm64_sequoia: "8796170b6bbce70bbd83832daa7c376b05f58ecf9e6194c12abc4a5c2db10b7f"
    sha256 cellar: :any, arm64_sonoma:  "7c10dffe0437fa57742024867ada8bbcd40fc67247973a1766442b04abbe4559"
    sha256 cellar: :any, sonoma:        "b1a927730ee6f60dd85502b5ef5bbb183e57bf68402204ece216f84ae0c66317"
    sha256 cellar: :any, arm64_linux:   "ba52029a8dcd73f2dc4e442ecd952d35dbbcdc706fa051356fad29c7b36d764e"
    sha256 cellar: :any, x86_64_linux:  "3290e483b1e2c2a52de776ac504b3682a97d86abb2a9b887402861caab0260ac"
  end

  depends_on "autoconf" => :build
  depends_on "autoconf-archive" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build

  depends_on "libtorrent-rakshasa"
  depends_on "xmlrpc-c"

  uses_from_macos "curl"
  uses_from_macos "ncurses"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--with-xmlrpc-c", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    pid = spawn bin/"rtorrent", "-n", "-s", testpath
    sleep 10
    assert_path_exists testpath/"rtorrent.lock"
  ensure
    Process.kill("HUP", pid)
  end
end