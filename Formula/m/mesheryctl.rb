class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.176",
      revision: "cff2c9f8117c331c21b8b672ef25ad2b97af6ef8"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0a82b8229ccfe4813e4ceab76dcea54b1734a7064e1ac20ed828a8c0af80a85c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0a82b8229ccfe4813e4ceab76dcea54b1734a7064e1ac20ed828a8c0af80a85c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0a82b8229ccfe4813e4ceab76dcea54b1734a7064e1ac20ed828a8c0af80a85c"
    sha256 cellar: :any_skip_relocation, sonoma:         "f9bae737a30dc9fc529af186faf39a08dff72dfb5da9070e6c64e91144e9a27e"
    sha256 cellar: :any_skip_relocation, ventura:        "f9bae737a30dc9fc529af186faf39a08dff72dfb5da9070e6c64e91144e9a27e"
    sha256 cellar: :any_skip_relocation, monterey:       "f9bae737a30dc9fc529af186faf39a08dff72dfb5da9070e6c64e91144e9a27e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cbbc6b723e484589ce35ab0638f60ef88863e77a22d1fad647686a2d93f07c2e"
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