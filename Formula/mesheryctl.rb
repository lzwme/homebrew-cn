class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.106",
      revision: "5c2a7681f614dc828eb5e99349abc500f9af7a0e"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dfdca339601ec3b3227962fdeea2c359a9cf4f955f29787d67006f2dacb024b5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dfdca339601ec3b3227962fdeea2c359a9cf4f955f29787d67006f2dacb024b5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dfdca339601ec3b3227962fdeea2c359a9cf4f955f29787d67006f2dacb024b5"
    sha256 cellar: :any_skip_relocation, ventura:        "1653c515254578ec180964ea68c930aa6cfbbf52749c934de0570700b48f7822"
    sha256 cellar: :any_skip_relocation, monterey:       "1653c515254578ec180964ea68c930aa6cfbbf52749c934de0570700b48f7822"
    sha256 cellar: :any_skip_relocation, big_sur:        "1653c515254578ec180964ea68c930aa6cfbbf52749c934de0570700b48f7822"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7a01d789758a4039280bef5e66aff3b0873e94161f056f605e6d8af6bd42038b"
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