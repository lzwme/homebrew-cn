class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.7.14",
      revision: "0218ef53dc2e932a7a791c8d0ddf9f4679db5926"
  license "Apache-2.0"
  head "https:github.commesherymeshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "404588bea85bb704116f4b0d8f6aa5cc494d23043c294a0a780bbe54c78ccdb1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "404588bea85bb704116f4b0d8f6aa5cc494d23043c294a0a780bbe54c78ccdb1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "404588bea85bb704116f4b0d8f6aa5cc494d23043c294a0a780bbe54c78ccdb1"
    sha256 cellar: :any_skip_relocation, sonoma:         "23933dca768f296e5a3b98e8b658f80ecac2e91f369f392ec885d3e45418b6a8"
    sha256 cellar: :any_skip_relocation, ventura:        "23933dca768f296e5a3b98e8b658f80ecac2e91f369f392ec885d3e45418b6a8"
    sha256 cellar: :any_skip_relocation, monterey:       "23933dca768f296e5a3b98e8b658f80ecac2e91f369f392ec885d3e45418b6a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c00f9ba98569e01a6e715e6c3e07312bb0a0e7f74ad8fd3aed18622c706f44fa"
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

    system "go", "build", *std_go_args(ldflags: ldflags), ".mesheryctlcmdmesheryctl"

    generate_completions_from_executable(bin"mesheryctl", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}mesheryctl version 2>&1")
    assert_match "Channel: stable", shell_output("#{bin}mesheryctl system channel view 2>&1")

    # Test kubernetes error on trying to start meshery
    assert_match "The Kubernetes cluster is not accessible.", shell_output("#{bin}mesheryctl system start 2>&1", 1)
  end
end