class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.103",
      revision: "40368c484fa39b437852980e6f169bb3aee47d8f"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0ddff0949691a5914db33a5f9f0aa222b03235b8efe9d3e7e10b8df9384e973c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0ddff0949691a5914db33a5f9f0aa222b03235b8efe9d3e7e10b8df9384e973c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0ddff0949691a5914db33a5f9f0aa222b03235b8efe9d3e7e10b8df9384e973c"
    sha256 cellar: :any_skip_relocation, ventura:        "a2144afd1fd8e69fa1244ffe7715758ed0ae6d251e4641bb8059ba7a05660f5d"
    sha256 cellar: :any_skip_relocation, monterey:       "a2144afd1fd8e69fa1244ffe7715758ed0ae6d251e4641bb8059ba7a05660f5d"
    sha256 cellar: :any_skip_relocation, big_sur:        "a2144afd1fd8e69fa1244ffe7715758ed0ae6d251e4641bb8059ba7a05660f5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "490e65510e4f5fed58894305a5a68ccf2e288d81b8d876d19b43e03ddca38f2d"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"

    ldflags = %W[
      -s -w
      -X github.com/layer5io/meshery/mesheryctl/internal/cli/root/constants.version=v#{version}
      -X github.com/layer5io/meshery/mesheryctl/internal/cli/root/constants.commitsha=#{Utils.git_short_head}
      -X github.com/layer5io/meshery/mesheryctl/internal/cli/root/constants.releasechannel=stable
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./mesheryctl/cmd/mesheryctl"

    generate_completions_from_executable(bin/"mesheryctl", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mesheryctl version 2>&1")
    assert_match "Channel: stable", shell_output("#{bin}/mesheryctl system channel view 2>&1")

    # Test kubernetes error on trying to start meshery
    assert_match "The Kubernetes cluster is not accessible.", shell_output("#{bin}/mesheryctl system start 2>&1", 1)
  end
end