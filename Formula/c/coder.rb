class Coder < Formula
  desc "Tool for provisioning self-hosted development environments with Terraform"
  homepage "https://coder.com"
  url "https://ghfast.top/https://github.com/coder/coder/archive/refs/tags/v2.30.6.tar.gz"
  sha256 "325b45c2048e94a61d44b822ee96b348105007a8403c6791fe6de5b4a22325f3"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c2542133a05d424e1e9e83121894693efe9a7908f0899a5750976f33955c5c28"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bedcd2779cd70c89f63877259071b4e21ee5fd75a1dd80db248013d5eef58185"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0fc29705caed747eab584f7b3670457305884ded1a506376ead23d1d1ce3d40b"
    sha256 cellar: :any_skip_relocation, sonoma:        "5fc8b38c30de40f2a801d5710fc57f5650002e38c36ec01fd8652a5120195968"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8badccae91c234b18b9839cb22adb3222c71530db5a36999984f90533c69e6f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "45227ae0bf5d336a6274d75b814c1ea55485423cb891afd0a94e11bb98f9eb63"
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