class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.8.196",
      revision: "a432fe8a42b375971fbba4b747f9332bc9861c01"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "21d4b50cbbc009506831d236fcfb1c6f8d8912b4ead938f03cd1d8abf214a0e5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b667e129d20e42526bbeee2194c1c06eb31aa74f9e6134ea72c2bd20f83cefe6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c924706d7f5817825717b55924466d3a9078cbabb3414f4f8cac35c719ce53ab"
    sha256 cellar: :any_skip_relocation, sonoma:        "7a21f9763b27d10754dd348f17db1262e372751f27016d58e14546a623339393"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3783a37f3b27c3f9f5b8749ecd93fc83a15f995de780d478f1195686d09e69b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "094e3d92fe956b6909b1b275c329f3106362b4b5dc6469d6f5ed01fb445f4f06"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0" if OS.linux?

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