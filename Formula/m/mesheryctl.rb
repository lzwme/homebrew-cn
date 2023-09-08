class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.136",
      revision: "3f36a0a4131a9ebe5edcb7687129694805d5af54"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4714cb35f3d90fc879060e21443d7816570f9b0002893ad757228325f96c4c22"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4714cb35f3d90fc879060e21443d7816570f9b0002893ad757228325f96c4c22"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4714cb35f3d90fc879060e21443d7816570f9b0002893ad757228325f96c4c22"
    sha256 cellar: :any_skip_relocation, ventura:        "e1c431ca8d98ad309012a92021d679c672eb5c9c956a7781d7c912fdb258497f"
    sha256 cellar: :any_skip_relocation, monterey:       "e1c431ca8d98ad309012a92021d679c672eb5c9c956a7781d7c912fdb258497f"
    sha256 cellar: :any_skip_relocation, big_sur:        "e1c431ca8d98ad309012a92021d679c672eb5c9c956a7781d7c912fdb258497f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bd081d9defe10d5636d3cba6aae5b5d082362db9f30c1014d93142afe5fe330a"
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