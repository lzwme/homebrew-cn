class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.8.153",
      revision: "2c9aaeaeb4ad3e78c66c6fb2dc712e467828c6a1"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "118157bbb12b2a355ed9415252e08d0f6a3c7255415484502e47e89abe79201f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "118157bbb12b2a355ed9415252e08d0f6a3c7255415484502e47e89abe79201f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "118157bbb12b2a355ed9415252e08d0f6a3c7255415484502e47e89abe79201f"
    sha256 cellar: :any_skip_relocation, sonoma:        "d37ece92dcd59cea79118617cde24cb9395a30b12e6f642b47af77342dd05edc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e1f6d3d74475da8db2a1ad22603fd95fd44708b4bd9beda3b486ebf41cf852b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2de27a2c6582f751e84b80428d7abb14af03f3eb0183adcdd4a984c5e148c4fd"
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