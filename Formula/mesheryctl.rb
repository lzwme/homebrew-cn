class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.68",
      revision: "9d6ed735642d81cb949f0cf8b6f8e8182e5471f0"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "01dbe82a88fd3f2335948fb7eedc24e2fbe3e648769abc534cb2e217347bfe7b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "01dbe82a88fd3f2335948fb7eedc24e2fbe3e648769abc534cb2e217347bfe7b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7ebcdb9248786e471e13984a6bbf78467aeda780e8ceb6435709499aea4466f5"
    sha256 cellar: :any_skip_relocation, ventura:        "bc75cef976df19eb832c22b9ae56418bbd6ece5548aa7d383431db9a0c9ded8c"
    sha256 cellar: :any_skip_relocation, monterey:       "bc75cef976df19eb832c22b9ae56418bbd6ece5548aa7d383431db9a0c9ded8c"
    sha256 cellar: :any_skip_relocation, big_sur:        "ffb3b9b7a8cd7834d10519f8cc095cf6a8594e7c0246b50732e1766c12b7d6c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "066afd2992d368aa48db1a8687b71bea4aa6d18fefa4bcf6dd8a45efd2d33e38"
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