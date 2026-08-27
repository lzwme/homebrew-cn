class Rtorrent < Formula
  desc "Ncurses BitTorrent client based on libtorrent-rakshasa"
  homepage "https://github.com/rakshasa/rtorrent"
  url "https://ghfast.top/https://github.com/rakshasa/rtorrent/releases/download/v0.16.21/rtorrent-0.16.21.tar.gz"
  sha256 "90eeee2312c1acf88d6602bbe6d331c9885346040436b87d37b034385e9505b2"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "ee50e2721da21ed410bac94dcd984ef692c9627a62db90363e2a002b7c27fd3f"
    sha256 cellar: :any, arm64_sequoia: "cb17f86a2b3a6c8afb96298ff71037d48de942e62ec06073cd323110bf7300d6"
    sha256 cellar: :any, arm64_sonoma:  "bd60ca7df9a314aea6d28d355ea2c607acefaecd950b2904db0e3e9347fb2f08"
    sha256 cellar: :any, sonoma:        "d99ce73e9ffe9057ffeaf3c684922a2416160be3ac4d7700d5b55788f13671c1"
    sha256 cellar: :any, arm64_linux:   "853fd1943a176e32a7bba01e266736e34fd3205a3aededa705cac00069863fe4"
    sha256 cellar: :any, x86_64_linux:  "277ae437920cb1115b08c358a4b5d7794c5b050eae538b4b0b925d0202c181ec"
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