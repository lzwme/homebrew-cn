class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v1.0.61",
      revision: "f993364ab34354ebe7e80c60384bf151b2fb9cbf"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2e094c9c069805a46a56a56b0952d49866c6ae6baff03a35434388365e19bb91"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0e9a076b797ea95dac218b1751be5c47c6d85b4133a3ac98fb57bb4df1068718"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0d1b240d669e19a521905d8f40def9ec8e4251855c3aab21fbe05b19dcb2b5b2"
    sha256 cellar: :any_skip_relocation, sonoma:        "64c8d265fa2767a4b24b50e9c4605171afce5506dadcedb82acca8dc6aaa2ebc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e12e4d8b3acd2fc41927e80a840e559f9510acefd598efed0a4ed94df912fdd1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fe39dce708e5f3fbd22f37352300d05a73868aa25059d991af4ff89652cd598c"
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