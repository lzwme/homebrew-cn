class BeadsViewer < Formula
  desc "Terminal-based UI for the Beads issue tracker"
  homepage "https://github.com/Dicklesworthstone/beads_viewer"
  url "https://ghfast.top/https://github.com/Dicklesworthstone/beads_viewer/archive/refs/tags/v0.25.2.tar.gz"
  sha256 "e8895e4de9beb68d243f37d4dd797af0e0223324da541737a1252a2dfa1b1a37"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7d898557aead2702aeb652442d2779056946da4438334a7f85368317021ff833"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7d898557aead2702aeb652442d2779056946da4438334a7f85368317021ff833"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7d898557aead2702aeb652442d2779056946da4438334a7f85368317021ff833"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "23b88278bf3eb1a6dc70b906ffcadccf5e4be7839aecbb4a6e12e5f38ffdf8d8"
    sha256 cellar: :any,                 x86_64_linux:      "74dc3233b62748942f9fa807362cea97ed79a48d041b628df0eb2178defa6e4b"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[-X github.com/Dicklesworthstone/beads_viewer/pkg/version.version=v#{version}]
    system "go", "build", *std_go_args(ldflags:, output: bin/"bv"), "./cmd/bv"
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/bv --version")

    # Test that it detects missing .beads directory.
    output = shell_output("#{bin}/bv --robot-insights 2>&1", 1)
    assert_match "failed to read beads directory", output
  end
end