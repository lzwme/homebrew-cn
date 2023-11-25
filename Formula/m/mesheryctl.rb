class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.181",
      revision: "9d7de53c6540c3aee9886d36fc1e29b16059aba0"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f91cb3fe18b6be5973524695d6988e69c4da7f3ddc46329c135802cf408bca1f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f91cb3fe18b6be5973524695d6988e69c4da7f3ddc46329c135802cf408bca1f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f91cb3fe18b6be5973524695d6988e69c4da7f3ddc46329c135802cf408bca1f"
    sha256 cellar: :any_skip_relocation, sonoma:         "e28fb4c240022051fe8c9d7dddda999e40c932b9515cb739f269f426c203d0a7"
    sha256 cellar: :any_skip_relocation, ventura:        "e28fb4c240022051fe8c9d7dddda999e40c932b9515cb739f269f426c203d0a7"
    sha256 cellar: :any_skip_relocation, monterey:       "e28fb4c240022051fe8c9d7dddda999e40c932b9515cb739f269f426c203d0a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ccab0a0fea8c9c7f6fe073a139f670ffdad8c43fd9da2d3875c59cba823890cd"
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