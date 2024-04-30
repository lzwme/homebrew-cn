class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.7.51",
      revision: "576dfe4653e40eb3fbd80fb65bc6df7c5b8719a4"
  license "Apache-2.0"
  head "https:github.commesherymeshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dc73ae41018eacedc3fe3c3664f630f943326339767c7a96c669e73df614c675"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dc73ae41018eacedc3fe3c3664f630f943326339767c7a96c669e73df614c675"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dc73ae41018eacedc3fe3c3664f630f943326339767c7a96c669e73df614c675"
    sha256 cellar: :any_skip_relocation, sonoma:         "8f8577061db278a49e88dfbea22814be8e85b1d7ac928f4cb215c01c94682554"
    sha256 cellar: :any_skip_relocation, ventura:        "8f8577061db278a49e88dfbea22814be8e85b1d7ac928f4cb215c01c94682554"
    sha256 cellar: :any_skip_relocation, monterey:       "8f8577061db278a49e88dfbea22814be8e85b1d7ac928f4cb215c01c94682554"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2aec2e26f9bd91ba8f5a3dc2a89e90a18c6fca95bad8689f66b5c5ffa199ff20"
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