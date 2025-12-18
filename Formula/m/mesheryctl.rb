class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.8.181",
      revision: "a0e17936228afcefc003c6377c33e9c06a699a92"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "127ed6dc200b02d679a100c716c76399732815dd43ebc528a836c7db96c5a791"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "127ed6dc200b02d679a100c716c76399732815dd43ebc528a836c7db96c5a791"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "127ed6dc200b02d679a100c716c76399732815dd43ebc528a836c7db96c5a791"
    sha256 cellar: :any_skip_relocation, sonoma:        "705c4719ac00aea9c3e18fd90449e595b5c87ad633d43dc25fff774ba84ff094"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aecedb7e835072d25f1305ab7986605c07e066fd73a5817124897040ebd222b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e6e357758213f9df593890f6b75163bbb431203d4aa8f6a0ddc54de8dafedad5"
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