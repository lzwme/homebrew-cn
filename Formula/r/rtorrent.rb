class Rtorrent < Formula
  desc "Ncurses BitTorrent client based on libtorrent-rakshasa"
  homepage "https://github.com/rakshasa/rtorrent"
  url "https://ghfast.top/https://github.com/rakshasa/rtorrent/releases/download/v0.16.12/rtorrent-0.16.12.tar.gz"
  sha256 "46e8b5e9b6daadaf5d3002a3bc5cbde25d6bdc0eb2f17177641cf47ce2d3ef86"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "db05d1872739eb1708a1546072c55520796acd3f6fc2d00b428a7c4e44952fbc"
    sha256 cellar: :any,                 arm64_sequoia: "e909167183bebdc7fce846ed55885335f899896eb4a71965f2ebb54d09035121"
    sha256 cellar: :any,                 arm64_sonoma:  "3b2c8c57d7d1a897f376c0ce072fa4837532267d58feab0135cab47ca8e2e614"
    sha256 cellar: :any,                 sonoma:        "082798e2f2d3b7fce48691fe5bc0af7c7bac5a72fc26e0e245e682cdb77aef62"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7a12d46c2e59f95990f17e0e372b6a46b566f94b73e6b83daae36f7b96aafd49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "24411c938327c2ab403e2e2dbb197341712d0aa3d171431f7098754e58753712"
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