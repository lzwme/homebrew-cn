class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.123",
      revision: "e1c7e96217b80fa1f2530b3b91af7385b74d6e1d"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f583c2ef3036154f104f2a603bec7033c803f24b54ea2fcbed8a1eed297d0077"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f583c2ef3036154f104f2a603bec7033c803f24b54ea2fcbed8a1eed297d0077"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f583c2ef3036154f104f2a603bec7033c803f24b54ea2fcbed8a1eed297d0077"
    sha256 cellar: :any_skip_relocation, ventura:        "904835d679bec1f96b745a3b13efcd3278af354aa9e8583d6f3229c53f42aaad"
    sha256 cellar: :any_skip_relocation, monterey:       "904835d679bec1f96b745a3b13efcd3278af354aa9e8583d6f3229c53f42aaad"
    sha256 cellar: :any_skip_relocation, big_sur:        "904835d679bec1f96b745a3b13efcd3278af354aa9e8583d6f3229c53f42aaad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "407066c63ff54b66fae7dd27fac579ba74f7a53f9943935e716f738c6ae454f1"
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