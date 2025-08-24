class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.8.129",
      revision: "0003d6e35e477dce85bd3efe94bff42e8bd94548"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5abc2fcd7d7e8bb0f763d7c3347cbff47cde58bbbfc43b45729255a801940330"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5abc2fcd7d7e8bb0f763d7c3347cbff47cde58bbbfc43b45729255a801940330"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5abc2fcd7d7e8bb0f763d7c3347cbff47cde58bbbfc43b45729255a801940330"
    sha256 cellar: :any_skip_relocation, sonoma:        "1445d24b4303acf6e4aa65c744ad5e2a91dd39a143dfcac39654712badf14f7d"
    sha256 cellar: :any_skip_relocation, ventura:       "1445d24b4303acf6e4aa65c744ad5e2a91dd39a143dfcac39654712badf14f7d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dd89594c7b6153a4711aaa83b993d37833ed7caf596b9d2dece9398caf6593c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a0c864e8763828a114e291e84b56746612ac629bb78cffa1cf086c8b90321c7e"
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