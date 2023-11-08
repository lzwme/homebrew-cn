class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.173",
      revision: "75867766ec9dc5c5a5fc56c54eaa8d321775bf2e"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7ef016a491c78877e1b7eef8b9d6dd0bcf7407cebcbb45d55cf0e5c4b801f7ba"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7ef016a491c78877e1b7eef8b9d6dd0bcf7407cebcbb45d55cf0e5c4b801f7ba"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7ef016a491c78877e1b7eef8b9d6dd0bcf7407cebcbb45d55cf0e5c4b801f7ba"
    sha256 cellar: :any_skip_relocation, sonoma:         "51a3d5f98e7867184f1d64bd2ed7ff135ee9678df0a09e7c590159018f6c7ccb"
    sha256 cellar: :any_skip_relocation, ventura:        "51a3d5f98e7867184f1d64bd2ed7ff135ee9678df0a09e7c590159018f6c7ccb"
    sha256 cellar: :any_skip_relocation, monterey:       "51a3d5f98e7867184f1d64bd2ed7ff135ee9678df0a09e7c590159018f6c7ccb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "06bde57355b216a6cc70c92659831164b178b2a9551c6d9abaf974ef8aa9417e"
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