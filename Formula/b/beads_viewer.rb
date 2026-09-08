class BeadsViewer < Formula
  desc "Terminal-based UI for the Beads issue tracker"
  homepage "https://github.com/Dicklesworthstone/beads_viewer"
  url "https://ghfast.top/https://github.com/Dicklesworthstone/beads_viewer/archive/refs/tags/v0.24.1.tar.gz"
  sha256 "b09713a0b58c5b1be7af1c8402db9855156f7b20594a9150333df9ae97fc0c4e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1e2214d36a10f7fcdd7e2e851d4ac953ac68c6fd59943fdd8037d367297fb326"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1e2214d36a10f7fcdd7e2e851d4ac953ac68c6fd59943fdd8037d367297fb326"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1e2214d36a10f7fcdd7e2e851d4ac953ac68c6fd59943fdd8037d367297fb326"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f0332db50e54a576b88e3065bb6e7a6278f2c36bd21efc9617a01f5772600e3a"
    sha256 cellar: :any,                 x86_64_linux:  "6b14fd59f3c35ef8ff53fb89e39db1e9e2245a9a5751057d17eaaedd9f8487ac"
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