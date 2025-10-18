class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.8.140",
      revision: "2568a152d0a6d0e601154382b448da6c13db8f97"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "efdce051fd429c7006fbb06d845eb89becd362d16c3b333d944b86acc19c18c1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "efdce051fd429c7006fbb06d845eb89becd362d16c3b333d944b86acc19c18c1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "efdce051fd429c7006fbb06d845eb89becd362d16c3b333d944b86acc19c18c1"
    sha256 cellar: :any_skip_relocation, sonoma:        "ce080e3350b5a2ca3e37c1f709abb3030be437767d7f567653040244dcc598cb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bb7c065a3fd76991fe63de2642f5163aefd8377da810bcf509c1c369f2ae2a2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "869282eff03b965803ab3b26fcdf7eb192f99530798962e98fa31a217c121904"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"

    ldflags = %W[
      -s -w
      -X github.com/meshery/meshery/mesheryctl/internal/cli/root/constants.version=v#{version}
      -X github.com/meshery/meshery/mesheryctl/internal/cli/root/constants.commitsha=#{Utils.git_short_head}
      -X github.com/meshery/meshery/mesheryctl/internal/cli/root/constants.releasechannel=stable
    ]

    system "go", "build", *std_go_args(ldflags:), "./mesheryctl/cmd/mesheryctl"

    generate_completions_from_executable(bin/"mesheryctl", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mesheryctl version 2>&1")
    assert_match "Channel: stable", shell_output("#{bin}/mesheryctl system channel view 2>&1")

    # Test kubernetes error on trying to start meshery
    assert_match "The Kubernetes cluster is not accessible.", shell_output("#{bin}/mesheryctl system start 2>&1", 1)
  end
end