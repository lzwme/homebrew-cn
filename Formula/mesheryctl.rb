class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.69",
      revision: "ce539487f210c69c5c5271ea87cdf8700558b453"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fc27e7e1a0939ea5c02f1f365318e2ef717bd28b3d398a8b04ae40597010c945"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "78196d15c596c7218e2c11478bfa4a60d6994b2f61fba05536c6998fb319ba4e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fc27e7e1a0939ea5c02f1f365318e2ef717bd28b3d398a8b04ae40597010c945"
    sha256 cellar: :any_skip_relocation, ventura:        "a9c30b214b70ad392c50dba50eaf4012522424792d111e611ab9a8412b513e28"
    sha256 cellar: :any_skip_relocation, monterey:       "e93463151e8ca8f9f34fadc4315e3d2e224a7b44eb5ff6fdbf5e897eaf9eed05"
    sha256 cellar: :any_skip_relocation, big_sur:        "e93463151e8ca8f9f34fadc4315e3d2e224a7b44eb5ff6fdbf5e897eaf9eed05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "762c9b1c2d25bed8899cbf9b40565c1db6cf2da6d5e05804a5c4c3031d1665ee"
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