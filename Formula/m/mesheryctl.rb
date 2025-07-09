class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.8.115",
      revision: "207fb2a038406a44ecd6715af795f773cd631848"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f36b629485086ded1590ba8878682ed593e902b5fe00be419f726a151c616009"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f36b629485086ded1590ba8878682ed593e902b5fe00be419f726a151c616009"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f36b629485086ded1590ba8878682ed593e902b5fe00be419f726a151c616009"
    sha256 cellar: :any_skip_relocation, sonoma:        "02af064ae89c897950eafc64bac941da77db4a1463bbb9498386a40752eaa315"
    sha256 cellar: :any_skip_relocation, ventura:       "02af064ae89c897950eafc64bac941da77db4a1463bbb9498386a40752eaa315"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0e1952411a611dd93c65cd41d0067638c106baa4c0e80f7776786e3b8b4b6182"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "47ac33dbc83c433ca5779e8f8ea027c49b632945b5ab12fadd9bad46bf1ce765"
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