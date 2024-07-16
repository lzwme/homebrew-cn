class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.7.83",
      revision: "6a8df8c0a6c9060ec08cbe0d065fdf168534f015"
  license "Apache-2.0"
  head "https:github.commesherymeshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "70cfa70e23f96ac5a49f7e4724ee03f57486119dcc7d4bcf8257f7e49b035d13"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "70cfa70e23f96ac5a49f7e4724ee03f57486119dcc7d4bcf8257f7e49b035d13"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "70cfa70e23f96ac5a49f7e4724ee03f57486119dcc7d4bcf8257f7e49b035d13"
    sha256 cellar: :any_skip_relocation, sonoma:         "bd8979ad62e0a940bd4d771e9a733c357d6f1cefbcecb813febc38551170de69"
    sha256 cellar: :any_skip_relocation, ventura:        "bd8979ad62e0a940bd4d771e9a733c357d6f1cefbcecb813febc38551170de69"
    sha256 cellar: :any_skip_relocation, monterey:       "bd8979ad62e0a940bd4d771e9a733c357d6f1cefbcecb813febc38551170de69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "297d45ee241047967289ab25e5c80215987d53e39e7f5c3f8b82772266f21b55"
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