class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.156",
      revision: "0b8e6a5f73c1390adff6eaeca70291a533de420c"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e3bc0930812bf1f12daac60557371d7e8264cae2bdb486a2f7c52454bf2a0691"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e3bc0930812bf1f12daac60557371d7e8264cae2bdb486a2f7c52454bf2a0691"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e3bc0930812bf1f12daac60557371d7e8264cae2bdb486a2f7c52454bf2a0691"
    sha256 cellar: :any_skip_relocation, sonoma:         "21b63b459bda06c13e98d4401a7e2ded2b0e0553ada71822acf5824ef69ac943"
    sha256 cellar: :any_skip_relocation, ventura:        "21b63b459bda06c13e98d4401a7e2ded2b0e0553ada71822acf5824ef69ac943"
    sha256 cellar: :any_skip_relocation, monterey:       "21b63b459bda06c13e98d4401a7e2ded2b0e0553ada71822acf5824ef69ac943"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "021d03b3f9d5318bae379acb7918c5fd15fa156b2de905c9c5ab8a33996b5a34"
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