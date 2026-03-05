class Coder < Formula
  desc "Tool for provisioning self-hosted development environments with Terraform"
  homepage "https://coder.com"
  url "https://ghfast.top/https://github.com/coder/coder/archive/refs/tags/v2.30.3.tar.gz"
  sha256 "8a37831c0ddfda8f9c95be68b6abe1ced8d3a742d325905d9c55553d5544c44f"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c93d508d5df0fa4847ef7ec31173588cb27cdb619ae4b820f5880f73dabfed4e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7e06c1395bf04d9872c423561181d6183fe2c760ac94941caa0f49d23ba26400"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fe3c34cde3d0b21ebf23c40caa3839e1d10169fdffaf88b34ec19149e37cfbd1"
    sha256 cellar: :any_skip_relocation, sonoma:        "6d7b54565ea576fc4d9f2d8c8c00df008d7874e1e7e4e155c3daf24443158512"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "45c9212f004943e8602795b893efabdf860b5a895e1e4d09bd79bde2a49b7ef9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6aa4a00ba2a2c264dbf8a80e816ecdb232aaa16eef9072d2f28f7a44b5dea0bd"
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