class Coder < Formula
  desc "Tool for provisioning self-hosted development environments with Terraform"
  homepage "https://coder.com"
  url "https://ghfast.top/https://github.com/coder/coder/archive/refs/tags/v2.37.6.tar.gz"
  sha256 "5928cb520ad16f42f328d770c29aa3711dbea291ee1d8ac1e6734c5973ac3ea9"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a2362ec3ad2b9e51a314ca901026b3a9996ffe65c5599dad0a40451ee802a2c9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "664b63cd4d431e8709218884e2f81296cb625e7cd01068c65c0de73d0b66fa4a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "62db0825e0d06984e9a4952ebb1e469698ca56cfacfdf8ec8a9cd8e347f928c9"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "88a579cbfc15ee307205d74684d09337f5895958e3fbcde7b7a9f69e20a1ede6"
    sha256 cellar: :any,                 x86_64_linux:      "b08e544b5873bd39d5e321eb305086c3a4fc75bf464448887e0f698791580ca5"
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