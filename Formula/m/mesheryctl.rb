class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.8.86",
      revision: "cecc7b5783c94ec5947c337a6204fdfc58190a40"
  license "Apache-2.0"
  head "https:github.commesherymeshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0f0299b677cd45a095ece4a6ea1c10366387c3ed35e1b6adacc57ce5ee4e9fa6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0f0299b677cd45a095ece4a6ea1c10366387c3ed35e1b6adacc57ce5ee4e9fa6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0f0299b677cd45a095ece4a6ea1c10366387c3ed35e1b6adacc57ce5ee4e9fa6"
    sha256 cellar: :any_skip_relocation, sonoma:        "e576806cf46947703edc65fb848c1f7110702634cc2d5f3c1f9f902f840fd10c"
    sha256 cellar: :any_skip_relocation, ventura:       "e576806cf46947703edc65fb848c1f7110702634cc2d5f3c1f9f902f840fd10c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "046925beaf14c82d5423d0328c6b404a02c6aea7842d91897a1a2be12b52e5b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a1b993a586579a0196b4bf7b0887788861f7b20012e24026a978c53be64d1046"
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