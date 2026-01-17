class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.8.198",
      revision: "824778db8e518ec86f9655d21966f30e6f49df91"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "20b71b8b01c4a39b28aec57020e8dc123ffa23c99feee6e62b1f6ca958acd799"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "db3ce2b264639cd679529268595783fcfee15efc43307548326cdcbb87d2fe56"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0e1c7be9ee7bafb2e4a385dc21248654eca3c01b13b7eadde33cc4fb276c547a"
    sha256 cellar: :any_skip_relocation, sonoma:        "1e58dfa147d370006836dfe8580bb96fb4e8ccf31384f3d7549d95feee58ca73"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "85094e1fb6104d33b1a6fcc3c2481aab5517c3b68bf7133b550cd7886cd576fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "29b70a0017ec29594b08e6d9acc2067cf22f40a218f603b3caf31db3c13ed1b9"
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