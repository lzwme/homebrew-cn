class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.8.192",
      revision: "4782d0b999d03ea88b3f9e29b8915766c85d574f"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "de5249fe006eeff2abd054b115db67b5cff1feeaaa5556b7635f708a426c9d26"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d8148a780c8c5423bb52cb772e5af928cd657370e8918fe40e973f1f8fa6b909"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f3a72993e2ff267af495534ae62f264f057a4486e87d98fc85d1a4be0bec2ce0"
    sha256 cellar: :any_skip_relocation, sonoma:        "871cb393a63a9db58c0326c7924b0c039105d3db86264457ad8fb9202cfe5e19"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "555f7b6761f5c75f9af620d86217434cc4479cc9dc8bb29ec974687369cd95ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d79a5858c7b74a46a829b733efdc50af36301b9070a7dc8de74dbac45c1f9ef4"
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