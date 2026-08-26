class Coder < Formula
  desc "Tool for provisioning self-hosted development environments with Terraform"
  homepage "https://coder.com"
  url "https://ghfast.top/https://github.com/coder/coder/archive/refs/tags/v2.35.6.tar.gz"
  sha256 "b6757b3e89c686e4b35490a0ef0080be05d8fc1d2f911c36c8516c04a3420a40"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0d4302e310a7919077188154c37607b8c1c330c5b565750d19195843f278efb4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e0aff26c13b1aef60b40bd266ea44d22b6e3520e04fb0fb1f55ee63911e5c9b8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2b21a6923d338bf54d7ce58e364cb89797026baa1d0838dc0d09025e013869c0"
    sha256 cellar: :any_skip_relocation, sonoma:        "f8d3e35fc284aa29a3bf1f5b69cc4f39a95af8ac558ff2d5b9b7e3cb9b833010"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "20564f6ad561b5f97f635e42f032275916aa4d95281b9a219bce02700ac0ba2b"
    sha256 cellar: :any,                 x86_64_linux:  "cc66130c217f8ab9ed8679c9bd4c6d92e97c31562cfa5750c67901798242c5e9"
  end

  # TODO: unpin go@1.26 when coder supports go 1.27
  depends_on "go@1.26" => :build

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