class Coder < Formula
  desc "Tool for provisioning self-hosted development environments with Terraform"
  homepage "https://coder.com"
  url "https://ghfast.top/https://github.com/coder/coder/archive/refs/tags/v2.36.7.tar.gz"
  sha256 "b7d9a712645ae54a2547f580d7d37961e86d0c930fe2e5120269ed64130b23bd"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "79c84a4de7fff2e1d8855f4828c2d40a5351034519e1362704c0dd08e7be67c8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "564ba0ddf76a4024e7bd187a3f66cfbe8f5c99050f2609c0b104db296ef9fc77"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2c12ad71356a5c31fc16103c4363f0290a8808b66ec465b330c29f3efd653ede"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "2462a10fc07bc0b6da00e6389f5e44a046ec67afcfd32dc946bd49b309413665"
    sha256 cellar: :any,                 x86_64_linux:      "9c0d24fc17623f83871aae6ae492debc53e06b54e8548b3866b66b785df9bc83"
  end

  # TODO: unpin go@1.26 when coder supports go 1.27
  depends_on "go@1.26" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
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