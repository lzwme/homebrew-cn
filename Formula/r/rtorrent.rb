class Rtorrent < Formula
  desc "Ncurses BitTorrent client based on libtorrent-rakshasa"
  homepage "https://github.com/rakshasa/rtorrent"
  url "https://ghfast.top/https://github.com/rakshasa/rtorrent/releases/download/v0.16.7/rtorrent-0.16.7.tar.gz"
  sha256 "f00ddb6ac2bb1fcda4116b94119f5ffb79af70afc2f115e64a3147955be757fc"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a82ceb74a141e9c6b97337d07bb578816ad88377244118056356341e7ffae839"
    sha256 cellar: :any,                 arm64_sequoia: "33dd6ddeb902d99f21033be843ca09a08b42bda901d50c1f7c57402eefac3f09"
    sha256 cellar: :any,                 arm64_sonoma:  "0544330a338f2c74d459d1986ef87e6c50e636545e44a40b84926e55b22b9e29"
    sha256 cellar: :any,                 sonoma:        "6a1ebd897ff9673cfae05842be96e3c871ce60a01b8cc82d80319d82d0424eba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1b03b4dd85335631fab57474fdc758534d6aa701390266eb1470d1e50767079a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "078d674f051580a11c21b378ba8ea529e6582a5668793b34c0321ea15d8e0d1f"
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