class Rtorrent < Formula
  desc "Ncurses BitTorrent client based on libtorrent-rakshasa"
  homepage "https://github.com/rakshasa/rtorrent"
  url "https://ghfast.top/https://github.com/rakshasa/rtorrent/releases/download/v0.16.24/rtorrent-0.16.24.tar.gz"
  sha256 "269d82054bdf3862194722c5e27bddc12abb51d45045bf6df1bd7ee3a2837bab"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "38849fae26896b102fa16c0b5f6c809da328003b10f7fbaa7b285010a223b874"
    sha256 cellar: :any, arm64_tahoe:       "3927e8f1ebf98e49f1f4dcb97b7b6dbbed78480c450230aa0e737479a0db274d"
    sha256 cellar: :any, arm64_sequoia:     "53e4868d951a043fe669b170fbf5dbbbdad6b8162c552ecaeeb9609eed5fc8b6"
    sha256 cellar: :any, arm64_linux:       "9a436e19383b34c97dd93c16db8db70532d745f3f8fa38c21889783737873e89"
    sha256 cellar: :any, x86_64_linux:      "3c8d2dd239df9e43af98e833f653df50d14c7e81f45d6ee96e76d65318d8c2d8"
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