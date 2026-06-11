class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v1.0.41",
      revision: "e38181b3f86e11cdb680cbe01b8e92a29129926f"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "46507315a69089a930511e4953090f8bcb9a0fdfe49e4adf36ed78c6cf496843"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8d81ea49f8c194d817c33f93e753338f244b8c02331bb2d15f55e6da6e1135d4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "81a55784c4b060cc45febd7e31d356ee7658a957c621f522a20d5003413743ed"
    sha256 cellar: :any_skip_relocation, sonoma:        "7c1c212805bed56e19af0323b67b242c50735f41aa3c8cfb16a4f92e055bab41"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e5e304a79e8a61a59e95645d6b71fb5eae7988e1a8ff31aee837f9ad3b5c3954"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "75673b26f69bfabbba0dc0a7096da8f4563eee31c811b6619625a16a4682f290"
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