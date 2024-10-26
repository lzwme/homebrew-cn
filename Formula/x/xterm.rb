class Xterm < Formula
  desc "Terminal emulator for the X Window System"
  homepage "https://invisible-island.net/xterm/"
  url "https://invisible-mirror.net/archives/xterm/xterm-395.tgz"
  mirror "https://deb.debian.org/debian/pool/main/x/xterm/xterm_395.orig.tar.gz"
  sha256 "286e3caa5938eae38e202827621567629dfeaae689e8070b413ca11398093dc8"
  license "X11"

  livecheck do
    url "https://invisible-mirror.net/archives/xterm/"
    regex(/href=.*?xterm[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "6da345bd09ba755ca3a9d0ad8396df2e544f832d4c94f24f2d480e26fdc08afe"
    sha256 arm64_sonoma:  "cc6e912e60d57b2abc2dc8bb14fa4aa6ba5a8724738e336df333461c914ba76f"
    sha256 arm64_ventura: "e302212168d002ea6334cfb5152f68d7f7df6e82bd5775b1f084151ae69e0cb9"
    sha256 sonoma:        "f52d6fd12e09e504106fc27267b67b50da3f7866371ed4197df3d10029d3178b"
    sha256 ventura:       "104061b3dda6a3387ddb6327201fee127367f8ebc30879d9b29cf48bb0a978c1"
    sha256 x86_64_linux:  "47fc6b48c2f4ca679c4970ac0ee320c484ac1acee8d5a5ef1a4b9d988148087e"
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