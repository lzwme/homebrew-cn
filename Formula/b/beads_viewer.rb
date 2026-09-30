class BeadsViewer < Formula
  desc "Terminal-based UI for the Beads issue tracker"
  homepage "https://github.com/Dicklesworthstone/beads_viewer"
  url "https://ghfast.top/https://github.com/Dicklesworthstone/beads_viewer/archive/refs/tags/v0.25.1.tar.gz"
  sha256 "ab22edf73e57f9b53a271f75753e6b6f2d081a80ba8318eaaa388a3ca1969679"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "47bb1561ebcf3f2e087b4ba7b82a4d8849c76ffcc95c279d11fbd537796e2cf9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "47bb1561ebcf3f2e087b4ba7b82a4d8849c76ffcc95c279d11fbd537796e2cf9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "47bb1561ebcf3f2e087b4ba7b82a4d8849c76ffcc95c279d11fbd537796e2cf9"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "dbc289f3e5a3dd0ecc1dbd6b563c31fb19a2caeed5d79fb6e11a9d6b7d72f605"
    sha256 cellar: :any,                 x86_64_linux:      "6e45ec3a8112b2aa21f8efbd8c6a8e53430a6804fd189cb1c18a39729b2b823e"
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