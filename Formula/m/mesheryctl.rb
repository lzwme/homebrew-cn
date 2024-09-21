class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.7.105",
      revision: "0f90501a63211d6828509c8b96ad0cfed7c08ca7"
  license "Apache-2.0"
  head "https:github.commesherymeshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "391c749f23d4372d04eaf47490e696d24e2154a43dcf7dc6a398e0825280345c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "391c749f23d4372d04eaf47490e696d24e2154a43dcf7dc6a398e0825280345c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "391c749f23d4372d04eaf47490e696d24e2154a43dcf7dc6a398e0825280345c"
    sha256 cellar: :any_skip_relocation, sonoma:        "150860df929cd75b6aeb4426cc71646a951af8f43d0d053cb7b1478aca31fa70"
    sha256 cellar: :any_skip_relocation, ventura:       "150860df929cd75b6aeb4426cc71646a951af8f43d0d053cb7b1478aca31fa70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ac2b8b72a8077b286a3ebfc4bec9f0045f8529aadb68f419e87479c85f548467"
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