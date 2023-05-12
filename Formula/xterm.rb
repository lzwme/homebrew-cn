class Xterm < Formula
  desc "Terminal emulator for the X Window System"
  homepage "https://invisible-island.net/xterm/"
  url "https://invisible-mirror.net/archives/xterm/xterm-380.tgz"
  mirror "https://deb.debian.org/debian/pool/main/x/xterm/xterm_380.orig.tar.gz"
  sha256 "0c1dc1fa800fa64b5c58d16ddb905e700b27ca538a65be8c03b2ba5761106c38"
  license "X11"

  livecheck do
    url "https://invisible-mirror.net/archives/xterm/"
    regex(/href=.*?xterm[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "1d0f7343b55be2d644818c73676d703d7b6294715c01e68a4b720b8c5f697359"
    sha256 arm64_monterey: "4bbba0f5b4860d8ecdb4eb7538274686095bce717b32b004634bed28791d9428"
    sha256 arm64_big_sur:  "0153a08b63ecde0ece80698aee63366414191bbdf18e7c9af33946893e785ff4"
    sha256 ventura:        "c041d8c4669d86a184cae7bc074a92b98e84a9a1a925ecff8d7502750915f6f1"
    sha256 monterey:       "80852c12be93be4a949a2398046be9e39fbffec69107f4f3328c789fb6089124"
    sha256 big_sur:        "6fc1c6e22fd6d8d6607c6863dc58bed8c624085c59af71ccdd197cd8786f60cc"
    sha256 x86_64_linux:   "24e07f31e7e0bce75deb6f01ea9c153621de4672500799e8c1b94f5c070f43b8"
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