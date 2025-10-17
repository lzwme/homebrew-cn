class Rtorrent < Formula
  desc "Ncurses BitTorrent client based on libtorrent-rakshasa"
  homepage "https://github.com/rakshasa/rtorrent"
  url "https://ghfast.top/https://github.com/rakshasa/rtorrent/releases/download/v0.16.1/rtorrent-0.16.1.tar.gz"
  sha256 "b2cdf8898b62f3763b29df94e4ad47d52cea2aa33b76581097a18894dd116073"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "175b33916379b6d049b2f8766bf4685312c437ad56be97d5995788fa2d900190"
    sha256 cellar: :any,                 arm64_sequoia: "98aa7b8bb25f3564a392c8be39d0ef8beb3a8248e62af969078371fb361658dc"
    sha256 cellar: :any,                 arm64_sonoma:  "e20270dea9d0c81f4e64c1abdcd9194aeff4abaf17900e3c0381f96bc086ef0f"
    sha256 cellar: :any,                 sonoma:        "86df3ef3254c6914f1835dfff81190703d5142ea908a5740d9e6a51109e60eaa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "18b850eeaf3e98485e6137cb6584a2065d70a948c35cd66e9f1f46ffd3ec220b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c0c1bae67240a21a39353280e465ac986851702d583c335a2b6f3923c6eefc77"
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