class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.8.160",
      revision: "57fb6dde3d0bbde4d8e662edb052745c44b6d8d0"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bda8517665d7daf8daaa01ee9dfa6d6a7cac74f3993012f2b4f18cbe5c439f75"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bda8517665d7daf8daaa01ee9dfa6d6a7cac74f3993012f2b4f18cbe5c439f75"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bda8517665d7daf8daaa01ee9dfa6d6a7cac74f3993012f2b4f18cbe5c439f75"
    sha256 cellar: :any_skip_relocation, sonoma:        "362cb022f0a7f562444089268e524babfb5a46aeb4412432988b38dca899fcc5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4307e82ba5af691c0e28caea28c234843fcac85495a8519c0e6718cbdd385388"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "405f3d987e44598cde3ffddcdd30f09e98e9233f8294947b125591e74c820e63"
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