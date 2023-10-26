class Libvterm < Formula
  desc "C99 library which implements a VT220 or xterm terminal emulator"
  homepage "http://www.leonerd.org.uk/code/libvterm/"
  url "https://launchpad.net/libvterm/trunk/v0.3/+download/libvterm-0.3.3.tar.gz"
  sha256 "09156f43dd2128bd347cbeebe50d9a571d32c64e0cf18d211197946aff7226e0"
  license "MIT"
  version_scheme 1

  livecheck do
    url :homepage
    regex(/href=.*?libvterm[._-]v?(\d+(?:\.\d+)+)\./i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "bed130ed0997c0946d15e1452aa9abd30048b6d193878f027cf836648864ab7a"
    sha256 cellar: :any,                 arm64_ventura:  "0e2015cf46c8c515721f3200ed53ad9b98385985ed3eb91cb4503270469bed17"
    sha256 cellar: :any,                 arm64_monterey: "dca8ab45e261d0c21e697a37a517ea23e545b4f8487dd7131ff5d933f80db5dc"
    sha256 cellar: :any,                 sonoma:         "bf0735a8ec7f8ce6d048b97f1851fa06c0a604a53ccc181fb793ce03e2714483"
    sha256 cellar: :any,                 ventura:        "1a6422cd35520a29dd3eb89b40c30526712d06ee2b3db9961e18d069a69a4ad9"
    sha256 cellar: :any,                 monterey:       "814b59c504a365bc66970c9056f83acd4b61cacb01d6c92bc0531a616a3893f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "63095180ed9b97bd7e357062fd1f0ecfc2a29ac51834a0264e6bfc08d631c614"
  end

  depends_on "libtool" => :build

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <vterm.h>

      int main() {
        vterm_free(vterm_new(1, 1));
      }
    EOS

    system ENV.cc, "test.c", "-L#{lib}", "-lvterm", "-o", "test"
    system "./test"
  end
end