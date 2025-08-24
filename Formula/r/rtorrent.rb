class Rtorrent < Formula
  desc "Ncurses BitTorrent client based on libtorrent-rakshasa"
  homepage "https://github.com/rakshasa/rtorrent"
  url "https://ghfast.top/https://github.com/rakshasa/rtorrent/releases/download/v0.15.6/rtorrent-0.15.6.tar.gz"
  sha256 "a3eb2afcdd0d81aaf5efd044761075f7f832375e9a6eb4b38a7694bfff3aa3cd"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "fde0cc9906b046c4f05fb4ca134d4423bc1a6cdbb94a03b33df9ca7879420a29"
    sha256 cellar: :any,                 arm64_sonoma:  "a57879cb70098eac77c6cd5aa71a5758fe6b79e9e53b3e120cb192702271a5fa"
    sha256 cellar: :any,                 arm64_ventura: "b005e3662c8dfd8dcf8518798ca4783b5bf9cea7b39cbd414b2ca7ba3253a962"
    sha256 cellar: :any,                 sonoma:        "4e3ecbc8ec0cbb930d9731a3d9f3ccc57c163b84f4d1bed833cc515e5cf1641f"
    sha256 cellar: :any,                 ventura:       "fb39bd2a2dd8f53be33915f8debf26fea7c37bdb60815b47ed2e38f78ba4110f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "579bd4a24f216c9ac2958f5f1a88982d3ef74170a75b106e6e1927188d92491c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f31817a3b11f9682f095913382c60b472ed50d7c1dabadba8a35b22cc0efd93f"
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