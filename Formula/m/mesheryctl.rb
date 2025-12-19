class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.8.190",
      revision: "3f4d5e8ed7c9431c0b566c60017b8fc51be3ab5a"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "43fcc2ffbc4ceeaf0ed30a541c304e568090311b466b0ff271aae2f218a81b82"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5e2c251fe3d23b3716ee8f6a402ccac992b8f86eeb4227f04d264b6c594862a9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fe14bb6633c0a8b48a3760129788a7902af8c12e13852ac2aaf246f3221326db"
    sha256 cellar: :any_skip_relocation, sonoma:        "005079bbb0e1509a84a601a45bca2f6856ad22d6e458c54f973a181d5f3d8d6f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "16089d226e0600f2e21560091648af373e560067c80ecbe8bebdfbc9c46a9359"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8ce21194768260bf93180cdf2b2508efdc32be0cc1b8e875b71e195925ccdef9"
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