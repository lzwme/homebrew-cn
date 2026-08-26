class BeadsViewer < Formula
  desc "Terminal-based UI for the Beads issue tracker"
  homepage "https://github.com/Dicklesworthstone/beads_viewer"
  url "https://ghfast.top/https://github.com/Dicklesworthstone/beads_viewer/archive/refs/tags/v0.21.2.tar.gz"
  sha256 "e54582db7d32a5bfd61dd523a6903e6766a3842445b7fd83c1d5f47d3ac094bd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b0c30157aa092f3e330bbcd909e3aeca42c36eb0209c188b32ffca9a2bd4f271"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b0c30157aa092f3e330bbcd909e3aeca42c36eb0209c188b32ffca9a2bd4f271"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b0c30157aa092f3e330bbcd909e3aeca42c36eb0209c188b32ffca9a2bd4f271"
    sha256 cellar: :any_skip_relocation, sonoma:        "139d510887ca8d3f08b8d0642f8a39bd56adad7699fbb1bb42afe62523846f6b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "693283fe6542539e55b25fb22b4aa9d522420720406c666bff5963eb981434c9"
    sha256 cellar: :any,                 x86_64_linux:  "70d863f6e869b2cd7ba9461c845a8ed397ee3cea4ccaa5ccd9be57117f2f527e"
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