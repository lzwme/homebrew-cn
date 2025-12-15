class Xterm < Formula
  desc "Terminal emulator for the X Window System"
  homepage "https://invisible-island.net/xterm/"
  url "https://invisible-mirror.net/archives/xterm/xterm-405.tgz"
  mirror "https://deb.debian.org/debian/pool/main/x/xterm/xterm_405.orig.tar.gz"
  sha256 "b6c05d0c7441939e422c45f7e28173b4a310cab986466485212a4e4b28255902"
  license "X11"

  livecheck do
    url "https://invisible-mirror.net/archives/xterm/"
    regex(/href=.*?xterm[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "c4a6b73005fca01a8a78d3bd5170f33132f7d1113cab981e6f75f04ef7b630d9"
    sha256 arm64_sequoia: "2e8eb1c42ee119f4fd19895f917e7b2394ae7948124f43e5cdfa47f116348daa"
    sha256 arm64_sonoma:  "2caeac3a5cd49d62c43f77a72640645bd345db22ed7b77232b806e1e946879c7"
    sha256 sonoma:        "d5af248e60e2dda4270d847a1087ffdc4c18a28ee8a415b5050102cc71382202"
    sha256 arm64_linux:   "cb9a629b4f83ea18455a10746fcbddc69d20fef27f8188e3db25868748281dd6"
    sha256 x86_64_linux:  "fb9a7027ed28361de0e8a78e2e2ef19f2f2fae9b044bd6de102f30d4689bd2ad"
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