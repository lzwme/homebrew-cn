class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.175",
      revision: "e143d45ac3172210c9aa6f4f146b717660e93d35"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "37a6c21e9d6941156060d85d290f449491471a7b03b00bc31ea0459eb8abaa4e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "37a6c21e9d6941156060d85d290f449491471a7b03b00bc31ea0459eb8abaa4e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "37a6c21e9d6941156060d85d290f449491471a7b03b00bc31ea0459eb8abaa4e"
    sha256 cellar: :any_skip_relocation, sonoma:         "452798d545ee6951c511f27b9f1af9a0b0a98827df81f3b0df2dc4a710c7eafd"
    sha256 cellar: :any_skip_relocation, ventura:        "452798d545ee6951c511f27b9f1af9a0b0a98827df81f3b0df2dc4a710c7eafd"
    sha256 cellar: :any_skip_relocation, monterey:       "452798d545ee6951c511f27b9f1af9a0b0a98827df81f3b0df2dc4a710c7eafd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "44443c080802817f4953adea8daa776e3422c8e60eb3308ececdef858213c888"
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