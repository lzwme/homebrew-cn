class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v1.0.42",
      revision: "e99498837a066c5da8f6e92dfb0ebfc4ef1885a0"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8336d76b68fa21be0001721871bd21e5ae6c6f05732290bf26293fb2a98448c6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f1121e6439c4e53fc64a91d2998201e09aa8b8143a99faa18c586e716e61a2f6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c8e55c1761bc89b32d560b57ed2c27ff3a2f94c58d392992e90b06f1ce11c2e1"
    sha256 cellar: :any_skip_relocation, sonoma:        "60401f9ea5cbcfb574169d3b48862aadece63e0a3fa9f9e05344c076c07db63b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "695bfb25551bfac607ed5623f4e54b34a4c2043900117e2fbcf3b947bccad2df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "02515ba82717a6808277ebf8a9a5465faafb34e32a68d7018f70eae4ca8224c0"
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