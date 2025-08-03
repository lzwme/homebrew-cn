class Xterm < Formula
  desc "Terminal emulator for the X Window System"
  homepage "https://invisible-island.net/xterm/"
  url "https://invisible-mirror.net/archives/xterm/xterm-401.tgz"
  mirror "https://deb.debian.org/debian/pool/main/x/xterm/xterm_401.orig.tar.gz"
  sha256 "3da2b5e64cb49b03aa13057d85e62e1f2e64f7c744719c00d338d11cd3e6ca1a"
  license "X11"

  livecheck do
    url "https://invisible-mirror.net/archives/xterm/"
    regex(/href=.*?xterm[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_sequoia: "0aaae0f8b970e81cb31f7dd74661d812bf87547e5b0605c5ebce9a5bee0c24eb"
    sha256 arm64_sonoma:  "f4fefb661fca3d23c28be7198fe86b421e8cc4ad05086d40216e0dc7672f4064"
    sha256 arm64_ventura: "f6fe15e8febdc0f2c76a552678b4cbe16b6b4bb8d48aac3578dc49eecf1b9556"
    sha256 sonoma:        "1ed3d657b98614f6167550cc3055ad7eb548c009db72b0a8382ee90d343d32f6"
    sha256 ventura:       "a68c705bd3d7480f128e0b74049271fe3a44e1b1b89775b6c36a43466225c504"
    sha256 arm64_linux:   "4ebf8da4b0580f7236c1b68cfa267003109a2d5dbd3e5b69cf3a0d7c4ac52431"
    sha256 x86_64_linux:  "2f148a9a67953517a9d3a060f94781b0eccfa670eba01b7154852251d032be30"
  end

  depends_on "pkgconf" => :build
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
      assert_path_exists bin/exe
      assert_predicate bin/exe, :executable?
    end
  end
end