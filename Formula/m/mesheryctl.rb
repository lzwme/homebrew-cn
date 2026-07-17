class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v1.0.56",
      revision: "c3cf2306a883ff226b58df66f7870345725b30c4"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0d0f0140ab31029f53be84f2adcfba999638456da5903622de90b1d60df04a05"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a27dba662f90d577e3a756da80bf2c2586c10f024050bb08159b5137347572af"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d144ad064e7a4cb2f41fc5fad7525208990f3c5b22bc62ffaf7687ed9f26a8d7"
    sha256 cellar: :any_skip_relocation, sonoma:        "c48a264fb8182e71d92d9ecc4f369ba236efce7d59589a6846aa2aacd2c84e7f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eca2f8bb68943ee7c3eb319de7c85ad165e82758d0f8bc213765aa9765ac16af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9f705b4ba5bdce7bf581964aa874046a57893f7ad5f99bebf35cd8d8aabe5d48"
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