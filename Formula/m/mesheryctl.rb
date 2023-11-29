class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.183",
      revision: "7b1955c998e611ea3730e8e92198e5fdc86ebca5"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7c6318d1ac0a7c2c0522634f1ecbb31721d8ee1d929af54582950b79de059cf2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7c6318d1ac0a7c2c0522634f1ecbb31721d8ee1d929af54582950b79de059cf2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7c6318d1ac0a7c2c0522634f1ecbb31721d8ee1d929af54582950b79de059cf2"
    sha256 cellar: :any_skip_relocation, sonoma:         "f6746f0bfdadde23f64558e7d9f42a757f47b131261699218563a95c950babb0"
    sha256 cellar: :any_skip_relocation, ventura:        "f6746f0bfdadde23f64558e7d9f42a757f47b131261699218563a95c950babb0"
    sha256 cellar: :any_skip_relocation, monterey:       "f6746f0bfdadde23f64558e7d9f42a757f47b131261699218563a95c950babb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ca0105dda73be2c2f24c662a57f196fd6e51e58c60dc493637225f1fdec16e4"
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