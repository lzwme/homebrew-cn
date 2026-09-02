class Coder < Formula
  desc "Tool for provisioning self-hosted development environments with Terraform"
  homepage "https://coder.com"
  url "https://ghfast.top/https://github.com/coder/coder/archive/refs/tags/v2.36.4.tar.gz"
  sha256 "184540bdd3c6bab56acf485f52351560632444ad5e42780c4d4a779bf00c6efc"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fbd3d40f8857fffaff7f7f2ac1cf2bd2b1a0cfba17ef47d1fbda2179fd5d25f3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "336303f44942432b1147d978c1ca8189ffba4d10ada4c5a21517f9b5dfc1c950"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "50a38d27fe3ef118fbf42fc886620ca88e6c16429dcf0881d3a0698208675b39"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6a1e5028640535bd33e2deeb078ab9b55dabee8fe2971f20818778e7da77c774"
    sha256 cellar: :any,                 x86_64_linux:  "d9e3f188c86c8c7b6dc954b34b8675d1d8168888f02d07f302fde2a9409b7863"
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