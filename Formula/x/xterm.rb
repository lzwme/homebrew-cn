class Xterm < Formula
  desc "Terminal emulator for the X Window System"
  homepage "https://invisible-island.net/xterm/"
  url "https://invisible-mirror.net/archives/xterm/xterm-396.tgz"
  mirror "https://deb.debian.org/debian/pool/main/x/xterm/xterm_396.orig.tar.gz"
  sha256 "43f94b6d0eecb4219a99f46352e746f2ab5558e40d922d411acff96cc778a6a5"
  license "X11"

  livecheck do
    url "https://invisible-mirror.net/archives/xterm/"
    regex(/href=.*?xterm[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "625a33432d0a2ccc6c02bf2b8125c8ce63ee2d2551534cbb46deb87bd1552602"
    sha256 arm64_sonoma:  "38d9e29430abbfa0ec4972a0317c434f7707bc77ee5b5ef9e228d97fe66334c7"
    sha256 arm64_ventura: "632c9f5717b08ac59da319a8c184ee2b429a21b01fdc82237ffc921dab4cac7f"
    sha256 sonoma:        "5d9741cc72cbbd7364e6f0fb3e0e2adb047cb08f37544d5461e3cd0a104bc0e1"
    sha256 ventura:       "6c71a98701c0703943f67b9d82b87240dbfb999eed51cc7bf6e3645d70ddee04"
    sha256 x86_64_linux:  "43ecc53b73a935e4368e79d79069f57c5fce5ff923f746f166f02f51d0f46578"
  end

  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "libice"
  depends_on "libx11"
  depends_on "libxaw"
  depends_on "libxext"
  depends_on "libxft"
  depends_on "libxinerama"
  depends_on "libxmu"
  depends_on "libxpm"
  depends_on "libxt"

  uses_from_macos "ncurses"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    %w[koi8rxterm resize uxterm xterm].each do |exe|
      assert_predicate bin/exe, :exist?
      assert_predicate bin/exe, :executable?
    end
  end
end