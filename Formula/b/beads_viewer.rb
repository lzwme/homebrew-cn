class BeadsViewer < Formula
  desc "Terminal-based UI for the Beads issue tracker"
  homepage "https://github.com/Dicklesworthstone/beads_viewer"
  url "https://ghfast.top/https://github.com/Dicklesworthstone/beads_viewer/archive/refs/tags/v0.17.0.tar.gz"
  sha256 "26aefd48cfe44cadeba22b032a276a6b62748fc114281709110d0b0b27630654"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6ec8c910e1c8b0da028a9cca36a4f49984adb71bfdb53c5085fe8e33830a28d9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6ec8c910e1c8b0da028a9cca36a4f49984adb71bfdb53c5085fe8e33830a28d9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6ec8c910e1c8b0da028a9cca36a4f49984adb71bfdb53c5085fe8e33830a28d9"
    sha256 cellar: :any_skip_relocation, sonoma:        "e2373ca2c3ecb6eb461ecd3ee78974561794422011a0d22da5bf338b0770a28e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1e763d642acc3441111704207a831e39ad6d0e7af998723a6f06d50288c1bc4e"
    sha256 cellar: :any,                 x86_64_linux:  "ecea64be646f24d509de57129afddd65392d1c9766a5a9a105da8892d839cf75"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/Dicklesworthstone/beads_viewer/pkg/version.Version=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"bv"), "./cmd/bv"
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/bv --version")

    # Test that it detects missing .beads directory.
    output = shell_output("#{bin}/bv --robot-insights 2>&1", 1)
    assert_match "failed to read beads directory", output
  end
end