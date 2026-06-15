class Rtorrent < Formula
  desc "Ncurses BitTorrent client based on libtorrent-rakshasa"
  homepage "https://github.com/rakshasa/rtorrent"
  url "https://ghfast.top/https://github.com/rakshasa/rtorrent/releases/download/v0.16.14/rtorrent-0.16.14.tar.gz"
  sha256 "d149fd4840065cc69da03caf051119593f10aa8d5b533811bc3bedc3da4a3c00"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "27f1e014dd8078f77399ec8ad43a1200ce18b08a72757962f04698fdffd52b80"
    sha256 cellar: :any, arm64_sequoia: "de6b5dc70668daedae681f4d9830431ff2c74ca2de0ae36af3dac9ab0974e8e9"
    sha256 cellar: :any, arm64_sonoma:  "31e9838e41517dcb367a40526c961f39967e6974441964dbc222e538de50416f"
    sha256 cellar: :any, sonoma:        "89b9aa93a4fac7236a9a17d3cf4e02e34c678b5611aeb6af2214d257e2c9ad24"
    sha256 cellar: :any, arm64_linux:   "257f5e3f707ebad6f775edc9f88f6d23509d929622b2b518bcd4b4099c222cfd"
    sha256 cellar: :any, x86_64_linux:  "20298094a9f1492db991442b9d27022e9436b041f8e2e4b522569577f3253732"
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