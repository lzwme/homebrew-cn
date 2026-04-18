class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v1.0.9",
      revision: "1a465018a05f565efb483e25812620ff69873320"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0f012687b1b02943b4f6837af696fc36031009daf51533a2f2ee4cd271d90ff5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a7c13326c0997d8459ef9e23b2c6c89756e168ee0d9b4360c679e757f6429f52"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a591c56708e7b50f567517871f2c8eb56d7685fc7e159200a9c58b906f9b09bb"
    sha256 cellar: :any_skip_relocation, sonoma:        "0953d072a1d60c60357b84f20900202a4ef6a2f297adf06b98cc2b83419b3dfa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bf5d8c4b715577bd1ffb4ff5884e7c52fc7603693e5235ff479654e99819ada6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f6cbf63791cad5da07942b1e0d3da10e6737a04affb3cf0f2067629716f4c541"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0" if OS.linux?

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