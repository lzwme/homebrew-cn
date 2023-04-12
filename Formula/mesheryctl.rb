class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.77",
      revision: "f792833ba3c0eeb8e3a0d775cba65a72fef46050"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2283ed3ea4d5709db312f6a5cdf76b730b555a8ad1356fb092cde538be2a9a23"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a9ef846d9b37bda140c575c0041d7ab5c6a94a9644bd7d86fed6c6e8bae7b5a8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2283ed3ea4d5709db312f6a5cdf76b730b555a8ad1356fb092cde538be2a9a23"
    sha256 cellar: :any_skip_relocation, ventura:        "f0281108cd39405f55dfc7f48c109d7cb1cd28836d5a7f364c6995621c1ec390"
    sha256 cellar: :any_skip_relocation, monterey:       "4eee7fd8439d47f724cdcd1771297ab074768497f6f01eb5b194e36b6823f82e"
    sha256 cellar: :any_skip_relocation, big_sur:        "f0281108cd39405f55dfc7f48c109d7cb1cd28836d5a7f364c6995621c1ec390"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "50bf277490df0f7cb6e28ddac71e6b57703ab29e4eef21661a9f57376bcb6147"
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