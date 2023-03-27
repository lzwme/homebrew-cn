class Unxip < Formula
  desc "Fast Xcode unarchiver"
  homepage "https://github.com/saagarjha/unxip"
  url "https://github.com/saagarjha/unxip.git",
      tag:      "v2.0",
      revision: "02f1e0dcb7362bb60b1c0e54f5d2ed3dea791343"
  license "LGPL-3.0-only"
  head "https://github.com/saagarjha/unxip.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "93c232832fc646962d1e983a237bd6f95024ac4fc62eaf20f2651297621b31e2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6890f08c026bc5c38858819aaae723138db92d6cd36104388ac31ac4294e676d"
    sha256 cellar: :any_skip_relocation, ventura:        "5cb9bf7de5d955966f7384186c981211b8f94502dcbaeb7cc5e7bbd185172d89"
    sha256 cellar: :any_skip_relocation, monterey:       "a5eb987258ffbd77e2591e87650a27f92c5d2d9ef69e64f4e3bb3be4669a08e5"
  end

  depends_on xcode: :build
  depends_on :macos
  depends_on macos: :monterey
  uses_from_macos "swift"

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release"
    bin.install ".build/release/unxip"
  end

  test do
    assert_equal "unxip #{version}", shell_output("#{bin}/unxip --version").strip

    # Create a sample xar archive just to satisfy a .xip header, then test
    # the failure case of expanding to a non-existent directory
    touch "foo.txt"
    system "xar", "-c", "-f", "foo.xip", "foo.txt"
    assert_match %r{^Failed to access output directory at /not/a/real/dir.*$},
      shell_output("2>&1 #{bin}/unxip foo.xip /not/a/real/dir", 1)
  end
end