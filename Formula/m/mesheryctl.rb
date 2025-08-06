class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.8.126",
      revision: "8fec09820001b6d40b84bfb734fa2d45c6599370"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "42ba8f31d2110d5b5a049d3eb68298caaee488e68652e2830533916a9c357cae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "42ba8f31d2110d5b5a049d3eb68298caaee488e68652e2830533916a9c357cae"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "42ba8f31d2110d5b5a049d3eb68298caaee488e68652e2830533916a9c357cae"
    sha256 cellar: :any_skip_relocation, sonoma:        "2071dad1a90c6a7e581d22a2a85773f8aeea57db9f6ce46088fee8482520ecf6"
    sha256 cellar: :any_skip_relocation, ventura:       "2071dad1a90c6a7e581d22a2a85773f8aeea57db9f6ce46088fee8482520ecf6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ddba97aae43051e7b985c9408b157414e0cc57c7861f30a997f5ca67e7417e6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ad1fc8d3bf3dada1932152ae5ceedda978a0110f5a2d4b32b2389f599b18589"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"

    ldflags = %W[
      -s -w
      -X github.com/meshery/meshery/mesheryctl/internal/cli/root/constants.version=v#{version}
      -X github.com/meshery/meshery/mesheryctl/internal/cli/root/constants.commitsha=#{Utils.git_short_head}
      -X github.com/meshery/meshery/mesheryctl/internal/cli/root/constants.releasechannel=stable
    ]

    system "go", "build", *std_go_args(ldflags:), "./mesheryctl/cmd/mesheryctl"

    generate_completions_from_executable(bin/"mesheryctl", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mesheryctl version 2>&1")
    assert_match "Channel: stable", shell_output("#{bin}/mesheryctl system channel view 2>&1")

    # Test kubernetes error on trying to start meshery
    assert_match "The Kubernetes cluster is not accessible.", shell_output("#{bin}/mesheryctl system start 2>&1", 1)
  end
end