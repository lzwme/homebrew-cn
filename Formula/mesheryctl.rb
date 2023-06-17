class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.97",
      revision: "7ebcee2f61da5d4ae27e10439cddb07e7326bace"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "88a185ab2a86a885f4d0187783cefedd1345fca256ae406447aa1e4966c5f829"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "88a185ab2a86a885f4d0187783cefedd1345fca256ae406447aa1e4966c5f829"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "88a185ab2a86a885f4d0187783cefedd1345fca256ae406447aa1e4966c5f829"
    sha256 cellar: :any_skip_relocation, ventura:        "0a98e6503f2768977cb08e1e0a17f036343d7ad41bb28a6e04596eb6d0f7ba9d"
    sha256 cellar: :any_skip_relocation, monterey:       "0a98e6503f2768977cb08e1e0a17f036343d7ad41bb28a6e04596eb6d0f7ba9d"
    sha256 cellar: :any_skip_relocation, big_sur:        "0a98e6503f2768977cb08e1e0a17f036343d7ad41bb28a6e04596eb6d0f7ba9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "14625cb5fb54aef11cde60f2410a9e7aa54387dc723c3824cfd941690cf98542"
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