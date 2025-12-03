class Rtorrent < Formula
  desc "Ncurses BitTorrent client based on libtorrent-rakshasa"
  homepage "https://github.com/rakshasa/rtorrent"
  url "https://ghfast.top/https://github.com/rakshasa/rtorrent/releases/download/v0.16.5/rtorrent-0.16.5.tar.gz"
  sha256 "62ebd7662d02bdff005bc29a4b3385238e703bbe2b0c845ea7ae1ffaf9cb66c8"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c620ce59759468e04a8ecb258d7817f5f3d07f27e52772d74efeb2cf583dbdcc"
    sha256 cellar: :any,                 arm64_sequoia: "3186b547a80776a25661958be4eabc9c424b2fd76fdb825545e8509dd7894bb9"
    sha256 cellar: :any,                 arm64_sonoma:  "a5478bed754f2347255d46025fdcc0ced6c1722cbee56ec8ec2a7d9be4db21a3"
    sha256 cellar: :any,                 sonoma:        "76dd96003bdeb828a82b741c62005eaaecfb2e379a519ef5a1ac2cac18eb4362"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bd5a41e8b3998e975effa2761f1a660a08bcba5a3485c1b480f7ecaa76f5049d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "19f638d8bbf9337de2c0326da00dd7d2fea4317d0e2f8a276902d73d7ff33311"
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