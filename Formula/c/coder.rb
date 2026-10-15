class Coder < Formula
  desc "Tool for provisioning self-hosted development environments with Terraform"
  homepage "https://coder.com"
  url "https://ghfast.top/https://github.com/coder/coder/archive/refs/tags/v2.37.4.tar.gz"
  sha256 "40c461d4fbf6c9b971c428a7bdcdb48e87c6e2e91c08d8d6417832d3f732aecf"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c231309ecb91dcaff5bf3b37a26baaadfadf187a467d72467f1d0801686c5172"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c61c912546eaf3d3fc8393096b7fe7d62fe582a185fe214e6e40c03f30503cce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e7ef55525e13b2246870cac964dc871ced6c9bee2dd1fcb2a5ca235e03fa6cc7"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7b92fbe3e46140a52fa45c58478c06797bc54813dee893d27f46c35f196fffa2"
    sha256 cellar: :any,                 x86_64_linux:      "5988d8d8a20c3402ec62f1b0bdaf7028e0c708ba31bfd4044de30c56f9caa4cb"
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