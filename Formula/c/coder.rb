class Coder < Formula
  desc "Tool for provisioning self-hosted development environments with Terraform"
  homepage "https://coder.com"
  url "https://ghfast.top/https://github.com/coder/coder/archive/refs/tags/v2.28.7.tar.gz"
  sha256 "d19147bc5c633515a858e7336a8f05b9fa5e2c96067cc3084dc948a32c89cbc0"
  license "AGPL-3.0-only"
  head "https://github.com/coder/coder.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4deef5236392e2ebfe59f4827966cc547e015612840d5bf0aa262cea38c1d014"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6b3aa835b3658638a0409c862eb18827f6e1c8c25ab7216f2d100ee6bcd0994a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5b7b37260d07de2c1fb06e20120062b11b8fbf3afdc9810b2d8fa6d75a80d274"
    sha256 cellar: :any_skip_relocation, sonoma:        "bccf54976f91a136aae6bf37a165f87f6139322425f8479f0a6e88d80f1e606f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f280d01eed661343a2326b66cfc57212d71ce886aed133426d3e91402b2c1227"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b1d5bd7987cc2fe27b1dd9b90006531a4213f022db61896c036d56ae1c73e489"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/coder/coder/v2/buildinfo.tag=#{version}
      -X github.com/coder/coder/v2/buildinfo.agpl=true
    ]
    system "go", "build", *std_go_args(ldflags:, tags: "slim"), "./cmd/coder"
  end

  test do
    version_output = shell_output("#{bin}/coder version")
    assert_match version.to_s, version_output
    assert_match "AGPL", version_output
    assert_match "Slim build", version_output

    assert_match "You are not logged in", shell_output("#{bin}/coder netcheck 2>&1", 1)
  end
end