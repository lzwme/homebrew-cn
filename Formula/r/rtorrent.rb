class Rtorrent < Formula
  desc "Ncurses BitTorrent client based on libtorrent-rakshasa"
  homepage "https://github.com/rakshasa/rtorrent"
  url "https://ghfast.top/https://github.com/rakshasa/rtorrent/releases/download/v0.16.19/rtorrent-0.16.19.tar.gz"
  sha256 "e082e625fffd62aa746352e268b1aa06bac732af23a0f8b7cff2b88306b6de8c"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "a27645a8301ef45ab5ed28efd05c34ea1edeb3a0ada43335074d43a9e63f933f"
    sha256 cellar: :any, arm64_sequoia: "fd5a35a42a186c379ca8009f4cf979c72c59cface717ecfdfea48812b0f4988c"
    sha256 cellar: :any, arm64_sonoma:  "bd3437303da03f4c49632193d309412bf1e62d3158e3fb210515181bbea5a08f"
    sha256 cellar: :any, sonoma:        "16fb2712afc4052b80b8de784db3c14d0762fc696d521e48511ab55e9e79bde4"
    sha256 cellar: :any, arm64_linux:   "258b7be4df79d86b5d92329e09719c12e96a96c33e038ebed0aea412113b00b1"
    sha256 cellar: :any, x86_64_linux:  "9999bbf99b19c59fd2d1f992675eceb1f342621bac4912e821ceaae730210768"
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