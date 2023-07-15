class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.108",
      revision: "e271627a47fc3a74d7ec02c6989acb478e1877b6"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3257cd88cada0ad475ea54087abdfc1c9429ad692b572fab45cdaa3f52254240"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3257cd88cada0ad475ea54087abdfc1c9429ad692b572fab45cdaa3f52254240"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3257cd88cada0ad475ea54087abdfc1c9429ad692b572fab45cdaa3f52254240"
    sha256 cellar: :any_skip_relocation, ventura:        "0a081b6296eab271d8827178323ff3ae04f704a700fc31c71d72cfbde757a95f"
    sha256 cellar: :any_skip_relocation, monterey:       "0a081b6296eab271d8827178323ff3ae04f704a700fc31c71d72cfbde757a95f"
    sha256 cellar: :any_skip_relocation, big_sur:        "0a081b6296eab271d8827178323ff3ae04f704a700fc31c71d72cfbde757a95f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "254ce69c2d74183cbfa4c7be9f4ced503e116a023290be4f542a72a6f3146c42"
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