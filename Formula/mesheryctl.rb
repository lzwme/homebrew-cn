class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.114",
      revision: "10ca1d1adca913b8f7dce923b9758d13e2cb998c"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "39ee311540f49aba6d4300003451e3b4a696dbb5d0cbcaec935a08b97c9b3207"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "39ee311540f49aba6d4300003451e3b4a696dbb5d0cbcaec935a08b97c9b3207"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "39ee311540f49aba6d4300003451e3b4a696dbb5d0cbcaec935a08b97c9b3207"
    sha256 cellar: :any_skip_relocation, ventura:        "bd6747cbd72d68e158ced6364426b3849c1330fd32bc037c13a31b9d94081a8c"
    sha256 cellar: :any_skip_relocation, monterey:       "bd6747cbd72d68e158ced6364426b3849c1330fd32bc037c13a31b9d94081a8c"
    sha256 cellar: :any_skip_relocation, big_sur:        "bd6747cbd72d68e158ced6364426b3849c1330fd32bc037c13a31b9d94081a8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "81a5980fc7efd340bce742f807a4cc357436610c879b94993731efea81508834"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"

    ldflags = %W[
      -s -w
      -X github.com/layer5io/meshery/mesheryctl/internal/cli/root/constants.version=v#{version}
      -X github.com/layer5io/meshery/mesheryctl/internal/cli/root/constants.commitsha=#{Utils.git_short_head}
      -X github.com/layer5io/meshery/mesheryctl/internal/cli/root/constants.releasechannel=stable
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./mesheryctl/cmd/mesheryctl"

    generate_completions_from_executable(bin/"mesheryctl", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mesheryctl version 2>&1")
    assert_match "Channel: stable", shell_output("#{bin}/mesheryctl system channel view 2>&1")

    # Test kubernetes error on trying to start meshery
    assert_match "The Kubernetes cluster is not accessible.", shell_output("#{bin}/mesheryctl system start 2>&1", 1)
  end
end