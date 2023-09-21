class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.143",
      revision: "70c66f209c2639fd9d8c587fdd4279019e0955df"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4e871e322ffcb29e1e617c8c86b59af9a91a1f8ad85060c74bad648f62fdbda3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4e871e322ffcb29e1e617c8c86b59af9a91a1f8ad85060c74bad648f62fdbda3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4e871e322ffcb29e1e617c8c86b59af9a91a1f8ad85060c74bad648f62fdbda3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4e871e322ffcb29e1e617c8c86b59af9a91a1f8ad85060c74bad648f62fdbda3"
    sha256 cellar: :any_skip_relocation, sonoma:         "3ea7bee86c004dc89b8bca723544eeab431735255a277610b84ff47f06b806b4"
    sha256 cellar: :any_skip_relocation, ventura:        "3ea7bee86c004dc89b8bca723544eeab431735255a277610b84ff47f06b806b4"
    sha256 cellar: :any_skip_relocation, monterey:       "3ea7bee86c004dc89b8bca723544eeab431735255a277610b84ff47f06b806b4"
    sha256 cellar: :any_skip_relocation, big_sur:        "3ea7bee86c004dc89b8bca723544eeab431735255a277610b84ff47f06b806b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c6df93c7e0856843f11116a411ce2f452731ca157ecd63885eeb006185eb098e"
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