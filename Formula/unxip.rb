class Unxip < Formula
  desc "Fast Xcode unarchiver"
  homepage "https://github.com/saagarjha/unxip"
  url "https://github.com/saagarjha/unxip.git", tag: "v1.1.3", revision: "b3ce1ab4728d4173390c97eddd28e821ad9e2974"
  license "LGPL-3.0-only"
  head "https://github.com/saagarjha/unxip.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bddf8b07397d4c839a0f320c354977d3622081e55920a2c41466ad6c39d68a74"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b26280852145a3c51e1b691f71cfb62793eb4c58d538be43397f9d6eec5dcdf4"
    sha256 cellar: :any_skip_relocation, ventura:        "19581f87ee5acb52288cb8187934b351e743cee640e75502302bc5ff750e9731"
    sha256 cellar: :any_skip_relocation, monterey:       "ad19fb1ab40d2cc0e0eaba1ada17451983da268a5a9535e0a7313308431f89f1"
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