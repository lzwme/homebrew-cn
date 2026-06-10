class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v1.0.40",
      revision: "928868bbd249d91babf6172c61d202c4047a1f32"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5738136eb20a8f304db9cf1bf90daf6f1b72f41c9609a929b83cc3fba90dc0cd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "69b1b8335728a70cf1e770a7f6513111f60d6fa3232470a8d55f914cf27d3357"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1a03d44956465e599261b83f9b495fa6d92c48ec92461ec540779c29cf2994f7"
    sha256 cellar: :any_skip_relocation, sonoma:        "b4901fb77166d8d027b34f554e584779da0abf4dbd42935848da6d786dfd725f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "468d4cb1558f1688bc794306cd374e9433ea4436b51332c83afab6802bbe8f06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0a6410798a3b0ddb9e7a324a862b93261d36c71ce57c088ed7b30982b30a5258"
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