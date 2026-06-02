class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v1.0.35",
      revision: "5f8b6a35ffc8ec1c0752398bb290e250e2dc1f41"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6148c323b3a3303f1cd2ba6e3f13837d691786e0fc1904151696b1be53539b70"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b81e34c08ee2631d3427fd38a710e44152326a37d28d29e47ec5a307a7860171"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3815070d06f02ade9560e6e1e710d47ae67ceb0b60035f0fa53d5d2ea693ee72"
    sha256 cellar: :any_skip_relocation, sonoma:        "9828023c88da8f62cbd064aecac27f24d9336f4af633962554609cd0c229b94f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0957fb633306e986aeee72aa7163283a3be6d04dbb148e8fb300a3bdbb92242a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1f6839943a322ec4f8f0d3b4ee264b47fae34c824ef1cc1d894559de6b5b9374"
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