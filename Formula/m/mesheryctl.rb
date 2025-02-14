class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.8.30",
      revision: "abab2f48c5d45e1c3bd70ab70655305ea1d57f4a"
  license "Apache-2.0"
  head "https:github.commesherymeshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ab3cb0ade38dd975b891e1b55c09945e32f1db2ce2879fbff9f468665593d149"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ab3cb0ade38dd975b891e1b55c09945e32f1db2ce2879fbff9f468665593d149"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ab3cb0ade38dd975b891e1b55c09945e32f1db2ce2879fbff9f468665593d149"
    sha256 cellar: :any_skip_relocation, sonoma:        "44723597c41bc0222b1f44165e60f6364344b853cf08298ab61c0fa3ff21e966"
    sha256 cellar: :any_skip_relocation, ventura:       "44723597c41bc0222b1f44165e60f6364344b853cf08298ab61c0fa3ff21e966"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "83ded9b2837bb304a5861d7ad08d5930c6409758ec1a0fb334dc76d38aeae475"
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