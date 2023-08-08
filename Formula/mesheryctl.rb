class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.118",
      revision: "e14f889fc20cf73ccc2325113e0cd2d822cb2ae3"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "44caf2b455923ad722fa07e813a697866e145a3f1af6f18ea26333ebc0d50683"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "44caf2b455923ad722fa07e813a697866e145a3f1af6f18ea26333ebc0d50683"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "44caf2b455923ad722fa07e813a697866e145a3f1af6f18ea26333ebc0d50683"
    sha256 cellar: :any_skip_relocation, ventura:        "9368108fe5ce6f0965c3f4a9c1dd4c5c30b637949ab0f2d0007100c181f9036a"
    sha256 cellar: :any_skip_relocation, monterey:       "9368108fe5ce6f0965c3f4a9c1dd4c5c30b637949ab0f2d0007100c181f9036a"
    sha256 cellar: :any_skip_relocation, big_sur:        "9368108fe5ce6f0965c3f4a9c1dd4c5c30b637949ab0f2d0007100c181f9036a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "287d85771498a36a27a712ebbb2cceac7851c15374c0fcb40771d428298f69fc"
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