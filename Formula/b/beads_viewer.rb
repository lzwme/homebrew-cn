class BeadsViewer < Formula
  desc "Terminal-based UI for the Beads issue tracker"
  homepage "https://github.com/Dicklesworthstone/beads_viewer"
  url "https://ghfast.top/https://github.com/Dicklesworthstone/beads_viewer/archive/refs/tags/v0.12.1.tar.gz"
  sha256 "8e9e89d0ede35a8abbb88ccd4e04007d08e8ef0be8be12433c13d648296321a5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6913c83cd1881429b751d54c7aaa76428f1f5871009b20bb49437f24f2be9f26"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6913c83cd1881429b751d54c7aaa76428f1f5871009b20bb49437f24f2be9f26"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6913c83cd1881429b751d54c7aaa76428f1f5871009b20bb49437f24f2be9f26"
    sha256 cellar: :any_skip_relocation, sonoma:        "f37fbded872aa9dc13515dda16c0043bc9c8412f073b638977aa50014930b6a9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b1ea8318033e58f8ee2d4f2de8753e4afb1a75608a9469a091b135878707f509"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4262a3125d7fcbd917b72449b5fd95fde5400f13b9420ec5cc0a1f7edcc1ffde"
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