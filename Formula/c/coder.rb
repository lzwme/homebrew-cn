class Coder < Formula
  desc "Tool for provisioning self-hosted development environments with Terraform"
  homepage "https://coder.com"
  url "https://ghfast.top/https://github.com/coder/coder/archive/refs/tags/v2.28.5.tar.gz"
  sha256 "a2bea571b7d70be0e55c9fafc4333d9d52347323b5a8e16ebd96291510f879da"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dfba200fdef481f5d59c7f805360cecffc5f1bab11eb14b69218d24d5ce23e55"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9fad7f03874f2d0f8928040911a2acfe203e9526daca582cdf9438b8c9467604"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "69e6530a5deaef448151e05567e9be4041ddc94fcc2a22c9cd77e31516a8fe2f"
    sha256 cellar: :any_skip_relocation, sonoma:        "968629f0ecef015814e65e594c62306d4c6b03200385752d0963c5e9c381bcdd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1cc1112de0b80d537e04940842e07548573c6c54d0c37ea769e4313b86e0a1ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ef994f1498a1c28aaa1e55322ef715ece14e7ccbb94425a86c619e2ca81e4d2"
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