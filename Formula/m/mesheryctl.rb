class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.177",
      revision: "f9e83c99ea483a3fd0da817076df0e3e268e606e"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6ca7e9bd904708ca29e5360c401292cc2d6c2fcc9698f7e207909dadec90aec0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6ca7e9bd904708ca29e5360c401292cc2d6c2fcc9698f7e207909dadec90aec0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6ca7e9bd904708ca29e5360c401292cc2d6c2fcc9698f7e207909dadec90aec0"
    sha256 cellar: :any_skip_relocation, sonoma:         "21abef7c57705b938fefc8d755fde322829fa3161d24e9d51c73f7a747d9ad08"
    sha256 cellar: :any_skip_relocation, ventura:        "21abef7c57705b938fefc8d755fde322829fa3161d24e9d51c73f7a747d9ad08"
    sha256 cellar: :any_skip_relocation, monterey:       "21abef7c57705b938fefc8d755fde322829fa3161d24e9d51c73f7a747d9ad08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed0297ca0417285cb878047052a84ea49cb8084209cbb91172037941e0822c10"
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