class BeadsViewer < Formula
  desc "Terminal-based UI for the Beads issue tracker"
  homepage "https://github.com/Dicklesworthstone/beads_viewer"
  url "https://ghfast.top/https://github.com/Dicklesworthstone/beads_viewer/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "effd425f140fd8cf7166402adac812963ae49c9b4b0ada483e5f45c9dd4493e6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f6ad517e6aff6dd6a032233c84b29be6db5c912e9e3c927142938561aa36d0c2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f6ad517e6aff6dd6a032233c84b29be6db5c912e9e3c927142938561aa36d0c2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f6ad517e6aff6dd6a032233c84b29be6db5c912e9e3c927142938561aa36d0c2"
    sha256 cellar: :any_skip_relocation, sonoma:        "9e05e8b72e13dd75c1649d54b67657f77b6880b90e2dc6526c3265d0a807e9ae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "24b5440c3f23b9cd855bb53c5ce45866a64cf00d7b554334197bd0b4a842019b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f453b553efa33650642bc2ba15e6d7f1f571696d93bfce3fecac7b75d88e0372"
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