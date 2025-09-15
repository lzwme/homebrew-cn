class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.8.132",
      revision: "54807dafa257f81602f005f90b1ee5a1fcf50517"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "95dac2f299b66e227cedb39ddedf7ac28fb4047c7f8b37965a15c9196fc26ed5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "46dbf70b316f5fd5ebd268c1dfcf4937e72fa9f9dc639a6c43fb4aaab4855708"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "46dbf70b316f5fd5ebd268c1dfcf4937e72fa9f9dc639a6c43fb4aaab4855708"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "46dbf70b316f5fd5ebd268c1dfcf4937e72fa9f9dc639a6c43fb4aaab4855708"
    sha256 cellar: :any_skip_relocation, sonoma:        "03016ec24c415e57d97213f4ef236f57cc74c495fc27a88c7bc6b86fcbba673e"
    sha256 cellar: :any_skip_relocation, ventura:       "03016ec24c415e57d97213f4ef236f57cc74c495fc27a88c7bc6b86fcbba673e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "26f18239f6f397a6cc25f2c7090e38acfbbddfd5dc4901a5f656db9692177f2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e900ca21247720421f0f9aea696fe2a75bffedc28cbc31f21d9e2782567a79f0"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"

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