class BeadsViewer < Formula
  desc "Terminal-based UI for the Beads issue tracker"
  homepage "https://github.com/Dicklesworthstone/beads_viewer"
  url "https://ghfast.top/https://github.com/Dicklesworthstone/beads_viewer/archive/refs/tags/v0.22.0.tar.gz"
  sha256 "8b29a221fcbd1fba8a866d31dc96825947ae988012f7ab4ffbb7f4cae375adfb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f7d0cbc2d5d37a44b3bf1f62cc751ea7de57ec321dc1052ca8ee0fe08275f421"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f7d0cbc2d5d37a44b3bf1f62cc751ea7de57ec321dc1052ca8ee0fe08275f421"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f7d0cbc2d5d37a44b3bf1f62cc751ea7de57ec321dc1052ca8ee0fe08275f421"
    sha256 cellar: :any_skip_relocation, sonoma:        "6a1714d54c39047e0827464003e47e83154f99a659eb38ca64063f8b7f2cd792"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "48a5af982527628b9641b898684b08bd7b60303184cacba61459cb3c29faa8fc"
    sha256 cellar: :any,                 x86_64_linux:  "36f5e41849b1cdd011699e32d6a5ae93130b92b81130795710282b37dbb8bee9"
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