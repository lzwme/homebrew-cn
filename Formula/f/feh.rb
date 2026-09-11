class Feh < Formula
  desc "X11 image viewer"
  homepage "https://feh.finalrewind.org/"
  url "https://feh.finalrewind.org/feh-3.13.tar.bz2"
  sha256 "dcbc79d4c00f8964eeed9edc82010eead8c1ed16c12e2ae116f2e7cc7cd94716"
  license "MIT-feh"

  livecheck do
    url :homepage
    regex(/href=.*?feh[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_golden_gate: "6307a1e4c001164c4e0446519d2889d16940ade7e81a2e8605cea3c951911408"
    sha256 arm64_tahoe:       "d7468fc199df0639c050b142f58970963029f9c72d43cf2e231bb9d563983bd8"
    sha256 arm64_sequoia:     "e8797436095f489ab39b1142505391333a1b2c1846f7ec8c15b817e62446757a"
    sha256 arm64_sonoma:      "ac457b94683c1cb13801b13701b0ad943c738a20c5cdf063d4e566d85f118c17"
    sha256 arm64_linux:       "bb0fd7501e36b1e2ad661a960f886a9fc0fb3e598ec6e7088d901516664cc4c9"
    sha256 x86_64_linux:      "502a0ea0da9be98fbd9a8e5eff4cffeab31fa56f8833bb00085773c21faa466d"
  end

  depends_on "imlib2"
  depends_on "libexif"
  depends_on "libpng"
  depends_on "libx11"
  depends_on "libxinerama"
  depends_on "libxt"

  uses_from_macos "curl"

  def install
    system "make", "PREFIX=#{prefix}", "verscmp=0", "exif=1"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/feh -v")
  end
end