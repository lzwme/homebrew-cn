class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.140",
      revision: "1474a6463ee904daf6a5b51268f9ed88d4628402"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e6ac6248aa9f91972fd52682986621c64aab9771b5f6ccf74412534cdc1f2a5a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e6ac6248aa9f91972fd52682986621c64aab9771b5f6ccf74412534cdc1f2a5a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e6ac6248aa9f91972fd52682986621c64aab9771b5f6ccf74412534cdc1f2a5a"
    sha256 cellar: :any_skip_relocation, ventura:        "0fb570026eeec17bd71d265642542fb046e7bd8be931c02fac04be56fc44dbb3"
    sha256 cellar: :any_skip_relocation, monterey:       "0fb570026eeec17bd71d265642542fb046e7bd8be931c02fac04be56fc44dbb3"
    sha256 cellar: :any_skip_relocation, big_sur:        "0fb570026eeec17bd71d265642542fb046e7bd8be931c02fac04be56fc44dbb3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eff53123f77caca4ea918d0f7929ffe2523aa78341a7c19ab18d70125f817f19"
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