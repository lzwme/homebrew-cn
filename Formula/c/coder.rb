class Coder < Formula
  desc "Tool for provisioning self-hosted development environments with Terraform"
  homepage "https://coder.com"
  url "https://ghfast.top/https://github.com/coder/coder/archive/refs/tags/v2.31.7.tar.gz"
  sha256 "598c2592392cd902ff786ddf69f3e30b8b0fbcf12d82763f4feb6d15be72acfa"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e5afc9554c0e70a35daea5df6ef4e6f59391ec804ea5a7c5cc4f1486755751f0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "786878fca1cce97d6685875a26acb7d0026d37bec3090d41f5c5a5431f53e6f7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0d6878c238a2d94edd4ebb4e733275c8cf3997c41579a6032719d7232f0d49de"
    sha256 cellar: :any_skip_relocation, sonoma:        "29ca51fff22705037483b699e4f4b73bc0b863a7dbc18b05dd6f25c8d10bb205"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b76b4b7f5f707ac64d655270bc424cff376e8de40c6f6f083b07281ac199026c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aee33c780276bc2fae3315f833a016aaa5442e6e25a61b1d3c00535709dda644"
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