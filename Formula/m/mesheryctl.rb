class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.8.0",
      revision: "3252d118f597e1f14ea719ac5ff804b4669e7f69"
  license "Apache-2.0"
  revision 1
  head "https:github.commesherymeshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9c97911cdce8ebddf15a2afa67dee57e5d49c279db1ab262dc728c25245694d8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9c97911cdce8ebddf15a2afa67dee57e5d49c279db1ab262dc728c25245694d8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9c97911cdce8ebddf15a2afa67dee57e5d49c279db1ab262dc728c25245694d8"
    sha256 cellar: :any_skip_relocation, sonoma:        "76258ad7ed059970ff01fa7d2aa85418a3971285530089199c8b53a1cf6fccc1"
    sha256 cellar: :any_skip_relocation, ventura:       "76258ad7ed059970ff01fa7d2aa85418a3971285530089199c8b53a1cf6fccc1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "88337733e2b4d541bc56c58810f654dd08547b534e15ba389b43c58b95383ec7"
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