class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.110",
      revision: "cae16007478003171e14f56639ff6ad1bcffdb10"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b579af30a1c363ee7b707a13cb958e460281345ed40ffd9fc4d46759928e3ba5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b579af30a1c363ee7b707a13cb958e460281345ed40ffd9fc4d46759928e3ba5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b579af30a1c363ee7b707a13cb958e460281345ed40ffd9fc4d46759928e3ba5"
    sha256 cellar: :any_skip_relocation, ventura:        "49ea09e1b19cd00107850480c80436c29e48c4d98c06ed2075c5a46501651d10"
    sha256 cellar: :any_skip_relocation, monterey:       "49ea09e1b19cd00107850480c80436c29e48c4d98c06ed2075c5a46501651d10"
    sha256 cellar: :any_skip_relocation, big_sur:        "49ea09e1b19cd00107850480c80436c29e48c4d98c06ed2075c5a46501651d10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2bb8744e352a61c21876d71f0498bb096f46caa50640dab1d95dd11d1031c415"
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