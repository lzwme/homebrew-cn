class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.120",
      revision: "4305fcaf756d54a1a950bab1f392a8a3b888ac7e"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1237508a81b7baf1a2edb1a1f44c10dc7d59fde5922e2aeac225219613a32c64"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1237508a81b7baf1a2edb1a1f44c10dc7d59fde5922e2aeac225219613a32c64"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1237508a81b7baf1a2edb1a1f44c10dc7d59fde5922e2aeac225219613a32c64"
    sha256 cellar: :any_skip_relocation, ventura:        "7eda823ebe8c42ace4061d232becb8361911d03257ac544461d199c6e597b40f"
    sha256 cellar: :any_skip_relocation, monterey:       "7eda823ebe8c42ace4061d232becb8361911d03257ac544461d199c6e597b40f"
    sha256 cellar: :any_skip_relocation, big_sur:        "7eda823ebe8c42ace4061d232becb8361911d03257ac544461d199c6e597b40f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "27bb060000aa72a7735645aadb50427835379016a083c7f62011cf1a9210e4b5"
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