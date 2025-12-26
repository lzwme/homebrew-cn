class Rtorrent < Formula
  desc "Ncurses BitTorrent client based on libtorrent-rakshasa"
  homepage "https://github.com/rakshasa/rtorrent"
  url "https://ghfast.top/https://github.com/rakshasa/rtorrent/releases/download/v0.16.5/rtorrent-0.16.5.tar.gz"
  sha256 "62ebd7662d02bdff005bc29a4b3385238e703bbe2b0c845ea7ae1ffaf9cb66c8"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f2160f16f3c7b2c1c6325734f877bbe1ac44d5a407d99c808b69d5f8bba881ab"
    sha256 cellar: :any,                 arm64_sequoia: "1b2f465e41bbff2eed0bbab27a18f377b433db243eeef2d3d4775e7c03e39c92"
    sha256 cellar: :any,                 arm64_sonoma:  "bd7e9508ba8333f60a661da0fffbb431996b68f3fba87ce1d3665a2b89acb8fd"
    sha256 cellar: :any,                 sonoma:        "fdb32943618e00c8565c48181a2871fcec319d4f8afcdd73205712375316cbdb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "47242e41656b494b02c29140b3f75fadfc6ecc597f1107b145f9c05c2b125c68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d9fc91cf791ba9902c3b689569e5c884857f90757847eba16582186cfe685cf"
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