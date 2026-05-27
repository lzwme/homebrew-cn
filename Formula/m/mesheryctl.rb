class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v1.0.30",
      revision: "a209d017925a75adf298c76319ce4c12de027837"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "22422d095b919eca45670f38b55f9bbcc94c3428736d7e8f9a6f2572bc5312a9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a2a29cd7ec9efd65a8a07166fda82886b8f7d811111ff64db03b0210e152cc8c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cb5cd0036cfc172a25c0d36abd1034cdc2f3c6dd3f92d564de615cf67b367d53"
    sha256 cellar: :any_skip_relocation, sonoma:        "d691cb521d91cdaa7a58268d777be6c0f0a5dcd045a9e43befa8c9a8b142a3a2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "51d84c80663b01dc33ce2748b2cc0c608098afcea9d2543db86e52fc515d43f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "43e3168715ae6826246d7ccda56a3e89f2de62f2be87ef91489f4e073ed3e591"
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