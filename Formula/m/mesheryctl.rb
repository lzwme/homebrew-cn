class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.8.117",
      revision: "9da37e3ab863f75379c015fe0d329b8ce59e9e27"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5653a767025d24b820ac4cc43e881daef9c5832123016f91d9fe9964a604b858"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5653a767025d24b820ac4cc43e881daef9c5832123016f91d9fe9964a604b858"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5653a767025d24b820ac4cc43e881daef9c5832123016f91d9fe9964a604b858"
    sha256 cellar: :any_skip_relocation, sonoma:        "e0b8a7c018ed085759a38d41fd0dc8d20683b251568214e9580c8bdae1ebd25e"
    sha256 cellar: :any_skip_relocation, ventura:       "e0b8a7c018ed085759a38d41fd0dc8d20683b251568214e9580c8bdae1ebd25e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b62929e074e39dd96bde20e8a74925905c3ba716fb2a31f96f5f164e18c07daf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "716d3d01c60935d248303ea83c24adff3bebb4991ec88ac8d9257b99005680fc"
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