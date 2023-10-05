class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.154",
      revision: "4cbb30637150f29c21ce7cbebdb2a77f56c8938e"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7647af733e78a02f97e4c87925d712f99d8fc1b4472f3ca151bb2421ae1042a6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7647af733e78a02f97e4c87925d712f99d8fc1b4472f3ca151bb2421ae1042a6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7647af733e78a02f97e4c87925d712f99d8fc1b4472f3ca151bb2421ae1042a6"
    sha256 cellar: :any_skip_relocation, sonoma:         "cf64fa76f03f6540e99011f65b3784f05d2bd3b556883e2fffd37cbf38a2e02e"
    sha256 cellar: :any_skip_relocation, ventura:        "cf64fa76f03f6540e99011f65b3784f05d2bd3b556883e2fffd37cbf38a2e02e"
    sha256 cellar: :any_skip_relocation, monterey:       "cf64fa76f03f6540e99011f65b3784f05d2bd3b556883e2fffd37cbf38a2e02e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ebe937f41b36dcda128c27d57729302435a1dcb1cf0c10187f1965a2f5aec5ac"
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