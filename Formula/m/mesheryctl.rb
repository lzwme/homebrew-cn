class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.8.118",
      revision: "967176239abc67bbed4b02bda58688bf2ab2bf1b"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4c7b0153429ba0d65170a41ef48a92575e5548ef9bafb2a5487cf9c940838486"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4c7b0153429ba0d65170a41ef48a92575e5548ef9bafb2a5487cf9c940838486"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4c7b0153429ba0d65170a41ef48a92575e5548ef9bafb2a5487cf9c940838486"
    sha256 cellar: :any_skip_relocation, sonoma:        "3800bc65ad0ff6acd42f6066cf5c2456f9a2b96f95c632b80309239ca08cff4e"
    sha256 cellar: :any_skip_relocation, ventura:       "3800bc65ad0ff6acd42f6066cf5c2456f9a2b96f95c632b80309239ca08cff4e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7c3b7b46324327bc71f92c304f65159b531cc84c5e3ea2bbdd797c5d631905f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cc407b9381eb2b3647d6f549199335ed9a957a1c7dcf47f17c2b5a7fec9d240d"
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