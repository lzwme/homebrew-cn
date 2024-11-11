class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.7.142",
      revision: "a411fcefff8f8e5d6e4bd9e4f214190f84210f78"
  license "Apache-2.0"
  head "https:github.commesherymeshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "95630f532368d87f3fce4cd9585090564866714239a252a2873e22f144b49ca2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "95630f532368d87f3fce4cd9585090564866714239a252a2873e22f144b49ca2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "95630f532368d87f3fce4cd9585090564866714239a252a2873e22f144b49ca2"
    sha256 cellar: :any_skip_relocation, sonoma:        "609f70891d5ee246b0d31de81ecba7033544b89f86c5f648b60246b5ed1890b8"
    sha256 cellar: :any_skip_relocation, ventura:       "609f70891d5ee246b0d31de81ecba7033544b89f86c5f648b60246b5ed1890b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "48852234e9abfa4c8aba521ff10cd2a099318dead14ba6a4a3c3a7a70cb1610f"
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