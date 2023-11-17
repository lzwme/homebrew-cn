class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://ghproxy.com/https://github.com/okteto/okteto/archive/refs/tags/2.22.3.tar.gz"
  sha256 "619faa62187e71605cab865e70c8bcf7c838988eb4d82ad7aafb9551328e258d"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "30a8f95324863f93584992ec0d79d9ffe007a434d2d1ddf1621acda4a26dd5d9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0996215365af54021ac105ef22721486de8841929fa02b3fe3e3ee8fccfa2dff"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "097cdf751256999beeb8e6012709495898668875f494abe62416f87cb526bc5e"
    sha256 cellar: :any_skip_relocation, sonoma:         "3d86853188f80a4d2fbdd386ca27770f99271835e83c15ecb13e5b9c89ccfc97"
    sha256 cellar: :any_skip_relocation, ventura:        "a777357fbf641f54f777c37b1eb55c1a90c2bd2bcb2086d34c6557e0c4b51e93"
    sha256 cellar: :any_skip_relocation, monterey:       "d1e9c12896378814e94099036dadbc97ca6cdfaf1aeb9bc301a21205d48fa6b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3f01a82152ac8bba3b40173a0ca03d438fa8802b33e722b0a9b81d50a6d4cdb9"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/okteto/okteto/pkg/config.VersionString=#{version}"
    tags = "osusergo netgo static_build"
    system "go", "build", *std_go_args(ldflags: ldflags), "-tags", tags

    generate_completions_from_executable(bin/"okteto", "completion")
  end

  test do
    assert_match "okteto version #{version}", shell_output("#{bin}/okteto version")

    assert_match "Please run 'okteto context' to select one context",
      shell_output(bin/"okteto init --context test 2>&1", 1)

    assert_match "Your context is not set",
      shell_output(bin/"okteto context list 2>&1", 1)
  end
end