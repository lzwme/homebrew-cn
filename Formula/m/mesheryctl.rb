class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.8.130",
      revision: "9c734481792fd4a80e83f68c706808ec41d5e10b"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "67a2f17efbb2e83f7bb9a937c90ae6332be3c75b8a97ce8c4e2911c2add30f9b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "67a2f17efbb2e83f7bb9a937c90ae6332be3c75b8a97ce8c4e2911c2add30f9b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "67a2f17efbb2e83f7bb9a937c90ae6332be3c75b8a97ce8c4e2911c2add30f9b"
    sha256 cellar: :any_skip_relocation, sonoma:        "cd67bc4fb72c9abb1b8a138cc2e96ebd78f1057579d3922c2e329013ff59a5af"
    sha256 cellar: :any_skip_relocation, ventura:       "cd67bc4fb72c9abb1b8a138cc2e96ebd78f1057579d3922c2e329013ff59a5af"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "732643464900089540ff44a7785cd73fbd0ac2b60b1312c59205eb4772496024"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "38d8dffc3a6413d0ccc33893949dbf4234b2a1c199b8d86a599740db9c756e06"
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