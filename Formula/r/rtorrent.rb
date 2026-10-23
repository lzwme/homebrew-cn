class Rtorrent < Formula
  desc "Ncurses BitTorrent client based on libtorrent-rakshasa"
  homepage "https://github.com/rakshasa/rtorrent"
  url "https://ghfast.top/https://github.com/rakshasa/rtorrent/releases/download/v0.16.26/rtorrent-0.16.26.tar.gz"
  sha256 "d10811b0678745e5c7b557c4394d54f7fd564d37cbdeb236d0e2f63a0f72918b"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "4aa3dca5906bf4de105f0c80f27be2fce97839b6800a671018840ac59a29215f"
    sha256 cellar: :any, arm64_tahoe:       "58cbb5b0ac4f276f4367a354cf3261b26f8d35eece77a983d598e88e2ad0e519"
    sha256 cellar: :any, arm64_sequoia:     "57b2b5f42463dbfa14b78cd3687c0995fb7a9e878e812c3fe1955f66bc0c4c81"
    sha256 cellar: :any, arm64_linux:       "1806d345162c97c8ad5efbe2b13c7d6f7ff7132f9fd27104f4f21003e1b1ceb0"
    sha256 cellar: :any, x86_64_linux:      "dfb24649129240f37bbd49400785bbc9c9bdf25981fb136f8df9b2f6ce66bedd"
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