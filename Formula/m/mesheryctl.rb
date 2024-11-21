class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.7.157",
      revision: "212fd7f6083e1936cc9810743fe1ffd1ca239b3d"
  license "Apache-2.0"
  head "https:github.commesherymeshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ec1417076ac668753c0459f62cdde49fec9b1a7ebfee5549bb23de9887c27a2b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ec1417076ac668753c0459f62cdde49fec9b1a7ebfee5549bb23de9887c27a2b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ec1417076ac668753c0459f62cdde49fec9b1a7ebfee5549bb23de9887c27a2b"
    sha256 cellar: :any_skip_relocation, sonoma:        "5c949efbb746f6e0ef4a87eb04cbd24137c85dda9c9f283a9454445283fecf7e"
    sha256 cellar: :any_skip_relocation, ventura:       "5c949efbb746f6e0ef4a87eb04cbd24137c85dda9c9f283a9454445283fecf7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "75e23052f4bf43dcff40de20188ed87138c6a8b3636946ff986f50a2ae03db25"
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