class Xterm < Formula
  desc "Terminal emulator for the X Window System"
  homepage "https://invisible-island.net/xterm/"
  url "https://invisible-mirror.net/archives/xterm/xterm-385.tgz"
  mirror "https://deb.debian.org/debian/pool/main/x/xterm/xterm_385.orig.tar.gz"
  sha256 "37592d8fef0b22bf2f62d8b840d3b22baff2b965265e8fe5b0582f0b1d637e55"
  license "X11"

  livecheck do
    url "https://invisible-mirror.net/archives/xterm/"
    regex(/href=.*?xterm[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "44159ea3423ddfa4ba99a34210514f5fec54891b45ef691a02b0ba3733343baa"
    sha256 arm64_ventura:  "9d2c78ee4f42c2be5949f25d0ff1a5f3fc7a78db78fecf8ee2a074b881897fd0"
    sha256 arm64_monterey: "22cc7e39f20b9b5a1fef5a0afb65ea08bbca59cd45bc30e3a7747404feb332f5"
    sha256 sonoma:         "b5fcaf1e25401e82c127579a9414d11f158b730ba55382d6dbe082b9b00665d1"
    sha256 ventura:        "036ad3b95037f3cac8496853deae162940b76921a4b9254056af71cff1c81847"
    sha256 monterey:       "4cca493f397d86bc7bcc08c2570a1e78cd5321ed6ebf3cfd2008ccd2c54a0aa1"
    sha256 x86_64_linux:   "d964ee17912db4afee48794a42de076f3d5645847ab1d865f3aa9103231588a2"
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