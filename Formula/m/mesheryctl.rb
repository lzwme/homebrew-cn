class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v1.0.65",
      revision: "d7e6acf893d48e2f4d9039ae9ec9894df265831e"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "109d34d846deca327b7aa4c5f5d5b88ef7ea1cac84bb1e0af689d3c68be0d6be"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "49a9eab60757959a4e45966f063bf6e3d7053493fd0fdf574f4d4a01be9ea161"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "176439c6e8fa334989357a9b0bede0c87b7e26cd40e8dd8ec57ed37ef5b582b5"
    sha256 cellar: :any_skip_relocation, sonoma:        "6000b3fcb9149f67aa12b35065991be63f797df53bd38fed80bbc996662576bb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "52493f00db334858957f158fa425d3007b0e9f79e5fa643735e6139f347de3af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "449ddceb970e91d8e35b94765743cb5fab9b18929d1e3bb78f351fd85707d541"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0" if OS.linux?

    ldflags = %W[
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