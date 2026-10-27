class Coder < Formula
  desc "Tool for provisioning self-hosted development environments with Terraform"
  homepage "https://coder.com"
  url "https://ghfast.top/https://github.com/coder/coder/archive/refs/tags/v2.37.7.tar.gz"
  sha256 "660f24911e7c48ff67cf0a0a09720f5bfb209f3c7de2af12dc7c165acd62cb67"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c0599e4a0859762ebfa069afbe1f7c1a1fe8112640a696525d5fa0b0b19cbefa"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "377ee16e127e12c878c24401b15acdccc9e3e97c35a6c68cfd2ffec9387b7818"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5691756be21b2f137991d882a83427e33670d50120efd2da526827417d9c672a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "23315a40d0922383b3f452d9578bd2020d3d991bf0d0933afffcdf4ae24c4b2d"
    sha256 cellar: :any,                 x86_64_linux:      "54db6ec76374d31bb5115e82d269d2204c52b5d0fcf45bde18396f4e0573309d"
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