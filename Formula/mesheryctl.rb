class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.84",
      revision: "304a7b6fdd663c06adaf18195251136c08d8d081"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "213c90db712bb7a6ea3fa10edc2d7e073857a487368fc11738cf88de42d42c29"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "622374affe130bc4bdb0ccf05929f41d6dda6b23287e8bf81659a25f95fffe5f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "622374affe130bc4bdb0ccf05929f41d6dda6b23287e8bf81659a25f95fffe5f"
    sha256 cellar: :any_skip_relocation, ventura:        "a9ea1ad0300b90d0855c26d2bf2536603fb7496e5d7051a6dbbc0703faed3b6b"
    sha256 cellar: :any_skip_relocation, monterey:       "a9ea1ad0300b90d0855c26d2bf2536603fb7496e5d7051a6dbbc0703faed3b6b"
    sha256 cellar: :any_skip_relocation, big_sur:        "a9c61446b24372782b3a0fc74489502aa32bbc719aa2622ebc48b670e6b16a06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "66c82f736f107f6646612e308d6d2dddd9644fd37147bf525cec9a8c29db37ff"
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