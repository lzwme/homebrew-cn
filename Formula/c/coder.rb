class Coder < Formula
  desc "Tool for provisioning self-hosted development environments with Terraform"
  homepage "https://coder.com"
  url "https://ghfast.top/https://github.com/coder/coder/archive/refs/tags/v2.30.2.tar.gz"
  sha256 "559fe584f998f9bd1ddebe59beb53effc5d45ec1a132ef90dc1e24ae68360ee9"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ec7f46d3acb77eca1d9b2e8b2d2d92df8b798a1bac5e322bd762f063f37d0308"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "688ecee79e4aec18048e9bfe93dd3aafb1d0d1a997146dd1570a59b9840e5ce5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1447fe965470985beba78dc4dcbefb9f0e93a6d3088ba744cc1874a8de92b9c0"
    sha256 cellar: :any_skip_relocation, sonoma:        "fffe298ebddfbb3afe53f5036eff4fc6df7fe00ac9cce138ead6bbe9dce0f44c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9b8044866dfc098f91bf9f4cca735eebc01664044c9cd381a18b35bdee988bca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cfa3b28d6aff496bec3fc574682b16d47604ac0e77eb6264e1a814de09c44aad"
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