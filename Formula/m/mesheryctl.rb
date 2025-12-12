class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.8.179",
      revision: "24573c85708050476d5c14d9c470c3544b77d876"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "57b87fcd4760c9f8ec2942ea025cad2e7d4fec885c8289b7e7bee80243b7694f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "57b87fcd4760c9f8ec2942ea025cad2e7d4fec885c8289b7e7bee80243b7694f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "57b87fcd4760c9f8ec2942ea025cad2e7d4fec885c8289b7e7bee80243b7694f"
    sha256 cellar: :any_skip_relocation, sonoma:        "5928139259e7c168c5e6720ea2446512b845c50988f96ce0281a6f6a999a8890"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e2c0829a52eefdf44c628d900a53d4fe5fe2b2d7dfffa25edad062aef09ac031"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf0bcc612995cb2136dfd59986cfcfeb5080830c47ac93cf92e0a7d272a88eea"
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