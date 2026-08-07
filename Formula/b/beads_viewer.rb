class BeadsViewer < Formula
  desc "Terminal-based UI for the Beads issue tracker"
  homepage "https://github.com/Dicklesworthstone/beads_viewer"
  url "https://ghfast.top/https://github.com/Dicklesworthstone/beads_viewer/archive/refs/tags/v0.19.0.tar.gz"
  sha256 "7459eeaa99976be78ea0a9f85f1db98e27011772a80ca5ec05d2125e0f86ce0a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d3e86242bd9c69febe0e94487ddec9b426a1b5108dd0ac4fe35f5046abe42cd5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d3e86242bd9c69febe0e94487ddec9b426a1b5108dd0ac4fe35f5046abe42cd5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d3e86242bd9c69febe0e94487ddec9b426a1b5108dd0ac4fe35f5046abe42cd5"
    sha256 cellar: :any_skip_relocation, sonoma:        "623f96ddcc8b1812979b902098bedb5e5e0117fbedc3d4f6fd7a7b6afe17206e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "19b67cab7f6d9fe324094b6a9bc237752c91231b28431d180a267389d2b872a0"
    sha256 cellar: :any,                 x86_64_linux:  "db17ff6080b6d7b440efce3811fb3ef6a566b362592bb8b96899928db7cd4b14"
  end

  depends_on "go" => :build

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