class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.7.77",
      revision: "4e1be916daaaa91ef816c81ea8412bfeb2e84882"
  license "Apache-2.0"
  head "https:github.commesherymeshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "df2c4ba08ddaa507a07bfdfc8128dd4d720822610f41eacbfc5e5795240d777e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "df2c4ba08ddaa507a07bfdfc8128dd4d720822610f41eacbfc5e5795240d777e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "df2c4ba08ddaa507a07bfdfc8128dd4d720822610f41eacbfc5e5795240d777e"
    sha256 cellar: :any_skip_relocation, sonoma:         "6dd86dd39115fa45e9d59e2aea371ec1c7522de727e13741f843af0f348cbef1"
    sha256 cellar: :any_skip_relocation, ventura:        "6dd86dd39115fa45e9d59e2aea371ec1c7522de727e13741f843af0f348cbef1"
    sha256 cellar: :any_skip_relocation, monterey:       "6dd86dd39115fa45e9d59e2aea371ec1c7522de727e13741f843af0f348cbef1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3f6574e73152c88e8aa2538ddf3728d90a132105c7da1c5cfbb2f9ac85014373"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"

    ldflags = %W[
      -s -w
      -X github.comlayer5iomesherymesheryctlinternalclirootconstants.version=v#{version}
      -X github.comlayer5iomesherymesheryctlinternalclirootconstants.commitsha=#{Utils.git_short_head}
      -X github.comlayer5iomesherymesheryctlinternalclirootconstants.releasechannel=stable
    ]

    system "go", "build", *std_go_args(ldflags:), ".mesheryctlcmdmesheryctl"

    generate_completions_from_executable(bin"mesheryctl", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}mesheryctl version 2>&1")
    assert_match "Channel: stable", shell_output("#{bin}mesheryctl system channel view 2>&1")

    # Test kubernetes error on trying to start meshery
    assert_match "The Kubernetes cluster is not accessible.", shell_output("#{bin}mesheryctl system start 2>&1", 1)
  end
end