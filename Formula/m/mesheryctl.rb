class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.167",
      revision: "44b4284875ab664c4288a60f1f25e62c8fbdc8c2"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "423f66641ce1f66831470ff33ea853c1ec888014de79a820020b1eea547c2774"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "423f66641ce1f66831470ff33ea853c1ec888014de79a820020b1eea547c2774"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "423f66641ce1f66831470ff33ea853c1ec888014de79a820020b1eea547c2774"
    sha256 cellar: :any_skip_relocation, sonoma:         "9c84d38e7cd437560a5e00a10451bb45ef0ce819ea7200f8a62451f72aba58aa"
    sha256 cellar: :any_skip_relocation, ventura:        "9c84d38e7cd437560a5e00a10451bb45ef0ce819ea7200f8a62451f72aba58aa"
    sha256 cellar: :any_skip_relocation, monterey:       "9c84d38e7cd437560a5e00a10451bb45ef0ce819ea7200f8a62451f72aba58aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "db10a55853a71bfc0e38ae32534a667f7baa597bf76caeebb41de7e968154c94"
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