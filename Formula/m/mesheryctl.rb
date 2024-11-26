class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.7.161",
      revision: "ac4066e217f2b2e211edc3356038d284208e478e"
  license "Apache-2.0"
  head "https:github.commesherymeshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "91a569035ffffaf5294cbc07bfbff765f7a98dd6b84fcf43433783a336e8509e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "91a569035ffffaf5294cbc07bfbff765f7a98dd6b84fcf43433783a336e8509e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "91a569035ffffaf5294cbc07bfbff765f7a98dd6b84fcf43433783a336e8509e"
    sha256 cellar: :any_skip_relocation, sonoma:        "7f5f2e07e4722f9ba31d9542ffdc0ee665142856162d9092306958be512266ed"
    sha256 cellar: :any_skip_relocation, ventura:       "7f5f2e07e4722f9ba31d9542ffdc0ee665142856162d9092306958be512266ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "68772bd282e21e35e45d939b2b28203373923e2fae9ea91795319ca66decd92f"
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