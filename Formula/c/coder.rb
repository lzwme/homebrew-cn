class Coder < Formula
  desc "Tool for provisioning self-hosted development environments with Terraform"
  homepage "https://coder.com"
  url "https://ghfast.top/https://github.com/coder/coder/archive/refs/tags/v2.26.2.tar.gz"
  sha256 "1f91155596ee1e93d2403612494ac45ba7b887a3cf04a1bc6bf8b5341a8fda4c"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ce18819f9267d99ef4d34ecb56556d50f84b97895f0e65a63f04b038dd193ec8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1369d689a1b3b2456d31f683fc792d17cb225d2fa6629a103220a97aefea13ee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d6964bbfe3c61bd243e132c0f49154c7f86fe728d3f39a03b6af87270cad11af"
    sha256 cellar: :any_skip_relocation, sonoma:        "1819d816a7cf2f0cd6d8ce91825c31f41c988209ace23ad56c3251a82dff9251"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b2a6752d09eb74dfea926e700c9800da6255ccf33e2b52acbf5e1e04aa125d18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c2d1901059ec8b50421cd06273be3465d6fa110d6313c9fb0c24df48205018b6"
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