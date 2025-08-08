class Coder < Formula
  desc "Tool for provisioning self-hosted development environments with Terraform"
  homepage "https://coder.com"
  url "https://ghfast.top/https://github.com/coder/coder/archive/refs/tags/v2.24.3.tar.gz"
  sha256 "de0975e3850a1d49e0b35f7dc7ebab6227948bbac095c3966a51debd3b1f9750"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8fb69de0f759a8f08dcdf195d56af95563874e9e19c52dff26620fb62df313d7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "702631d40b1abf022abecdb8f6b6f0b7bf4514c81c60bc62d86c9bc0a6b6d15b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ca5fd3ca45e9637cdc12f2b7508587e738585f27c094e027e059b55e2a90aa88"
    sha256 cellar: :any_skip_relocation, sonoma:        "eeae1a20b506fbc9a9ed4651895a034560eb832a77a13685c49e881ceebab2cd"
    sha256 cellar: :any_skip_relocation, ventura:       "ed008d9a6084dd6ef8b4452313e94d6925d3fcc34281fdcc60484817f5c52f4e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f0f49c04e35b8adba76d72defdea7d75245c52058c89e03faf9f6acdac37c548"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e5b033c00c142120b9febcb4166bcdff3c7d680d9aaa9fd2c8a4534d3d02defa"
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