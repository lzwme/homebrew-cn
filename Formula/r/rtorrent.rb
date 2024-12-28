class Rtorrent < Formula
  desc "Ncurses BitTorrent client based on libtorrent-rakshasa"
  homepage "https:github.comrakshasartorrent"
  url "https:github.comrakshasartorrentreleasesdownloadv0.15.0rtorrent-0.15.0.tar.gz"
  sha256 "cd2a590776974943fcd99ba914f15e92f8d957208e82b9538e680861a5c2168f"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a204299b1852d2abd2445b17f6c92bcb25117674d4a6bc8631f209cae1eac0df"
    sha256 cellar: :any,                 arm64_sonoma:  "36e4d19a9d75f76631ac8f545a79d2b63af26feba0192e3befe5a041aeb03a41"
    sha256 cellar: :any,                 arm64_ventura: "8b7a23cbe3d5c06b1900f6d8d9fcf9eeefa904ad7cc3a5bffaca7948c67528a0"
    sha256 cellar: :any,                 sonoma:        "66c6240d8c1ae9d019367000d685edb2b5687cd7e8556ac72806ffd3d8f97b99"
    sha256 cellar: :any,                 ventura:       "63df496e9f7bb11dd5d3d97003aace7c1f60b52b064aa21e451c91cf2eb40c8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b9ec5203996558995d0cb0c5dd85f97a6256b4825f40fce9e7044d21129f6b79"
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
    system ".configure", "--with-xmlrpc-c", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    pid = spawn bin"rtorrent", "-n", "-s", testpath
    sleep 10
    assert_path_exists testpath"rtorrent.lock"
  ensure
    Process.kill("HUP", pid)
  end
end