class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.141",
      revision: "1e450b1aa9f371b1b268ee210d1b63299acdaad7"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "97b8ff4c1e92c8fe3f3da4ccfa11aa2f5bb8edc0b23e2c73396b02c8a55a24e2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "97b8ff4c1e92c8fe3f3da4ccfa11aa2f5bb8edc0b23e2c73396b02c8a55a24e2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "97b8ff4c1e92c8fe3f3da4ccfa11aa2f5bb8edc0b23e2c73396b02c8a55a24e2"
    sha256 cellar: :any_skip_relocation, ventura:        "ff017184e068086fd7cbf40349fcaa92b0903a55d91023ced23e66d0da7f9b10"
    sha256 cellar: :any_skip_relocation, monterey:       "ff017184e068086fd7cbf40349fcaa92b0903a55d91023ced23e66d0da7f9b10"
    sha256 cellar: :any_skip_relocation, big_sur:        "ff017184e068086fd7cbf40349fcaa92b0903a55d91023ced23e66d0da7f9b10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "abc9b5ab7d886681c04e5aa2c334afe233df1c494f4c93477e2f8b675c35df6a"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"

    ldflags = %W[
      -s -w
      -X github.com/layer5io/meshery/mesheryctl/internal/cli/root/constants.version=v#{version}
      -X github.com/layer5io/meshery/mesheryctl/internal/cli/root/constants.commitsha=#{Utils.git_short_head}
      -X github.com/layer5io/meshery/mesheryctl/internal/cli/root/constants.releasechannel=stable
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./mesheryctl/cmd/mesheryctl"

    generate_completions_from_executable(bin/"mesheryctl", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mesheryctl version 2>&1")
    assert_match "Channel: stable", shell_output("#{bin}/mesheryctl system channel view 2>&1")

    # Test kubernetes error on trying to start meshery
    assert_match "The Kubernetes cluster is not accessible.", shell_output("#{bin}/mesheryctl system start 2>&1", 1)
  end
end