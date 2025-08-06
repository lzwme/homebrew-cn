class Coder < Formula
  desc "Tool for provisioning self-hosted development environments with Terraform"
  homepage "https://coder.com"
  url "https://ghfast.top/https://github.com/coder/coder/archive/refs/tags/v2.24.2.tar.gz"
  sha256 "0b0da9fb2835b673c6646a78273c2503fd5d3f80af515763fca1c53bf2fc17b8"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ca26d7206c7cc04f640f7de7fad0a08f7a04d586cf2e512840b18db0b62f24ca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1455fae299ecd4f96b6e752a8563c873a725a9a49415fdd1111ecc25bb9d5272"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "88c4db434a2ac5f9d2b21c89162200e900c0c3c539bb726cbd11e7772ef7f1bc"
    sha256 cellar: :any_skip_relocation, sonoma:        "487b46776a9545b09c41a34c51a7d2a4452d577265784ed6124a26328b19ec73"
    sha256 cellar: :any_skip_relocation, ventura:       "4e2219aad24696b235fdc9751c333dd6a4de45521a8a98fb1af2395f87f6a439"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "16290cc9e804083c26c3e1aa787246e4ca3a44853c1f0542a2be34e6312c88d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6134ae6bd2841557fde99e13882633357189719559203bbe0a1b0a880e314ab5"
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