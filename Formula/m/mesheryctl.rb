class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.7.80",
      revision: "62708bb21e972d05161ce0e94223a68c8fdcf3ce"
  license "Apache-2.0"
  head "https:github.commesherymeshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "36814ceb3287213ca1fc588bdf42afad32fb79a5848934b849ddb55c4e2c7cfb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "36814ceb3287213ca1fc588bdf42afad32fb79a5848934b849ddb55c4e2c7cfb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "36814ceb3287213ca1fc588bdf42afad32fb79a5848934b849ddb55c4e2c7cfb"
    sha256 cellar: :any_skip_relocation, sonoma:         "475dfffe0393583e35c3b5b1663dcad3a9f7089d781b51bb8f81cc54bc9bdd12"
    sha256 cellar: :any_skip_relocation, ventura:        "475dfffe0393583e35c3b5b1663dcad3a9f7089d781b51bb8f81cc54bc9bdd12"
    sha256 cellar: :any_skip_relocation, monterey:       "475dfffe0393583e35c3b5b1663dcad3a9f7089d781b51bb8f81cc54bc9bdd12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1b8d4472bed4d5e5c7c78cf7c05e8ba56a093e245af54432bba1b19e29ad880b"
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