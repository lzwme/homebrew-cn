class Xterm < Formula
  desc "Terminal emulator for the X Window System"
  homepage "https://invisible-island.net/xterm/"
  url "https://invisible-mirror.net/archives/xterm/xterm-391.tgz"
  mirror "https://deb.debian.org/debian/pool/main/x/xterm/xterm_391.orig.tar.gz"
  sha256 "6091371e94de867ce186cc1bc306947b0482d71631847fdeab7982acb20ae6b8"
  license "X11"

  livecheck do
    url "https://invisible-mirror.net/archives/xterm/"
    regex(/href=.*?xterm[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "479fdc4cc40a9bb0ca10bd5a7ad3dbd3be9f3faa9078c2deb798221edc25e496"
    sha256 arm64_ventura:  "7f4a041bc1ca340bf7679676712ea8b78e1ec668b66f33e4286c0b61f2c35a9d"
    sha256 arm64_monterey: "48276f09846bcd27039d3ef9ca5357cce792610d5f23a2f83d435fe09a887fab"
    sha256 sonoma:         "863e100472f7cfd716dc23b9bc74c9a4b9978e2e3c3efaa79f62372e92a93fd0"
    sha256 ventura:        "38affdd144f9197e4e27b622e4fa9afd5a8c2a3de518382fdaaabe103618b6a3"
    sha256 monterey:       "3603239ffafd170fae6685b92b61a204a037a6a6ed85e51274b5c27c24b337b9"
    sha256 x86_64_linux:   "61790986e837892f7d178b09cabdb9fcbc4f741069426f16c9a09947376aaaba"
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