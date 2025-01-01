class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.8.3",
      revision: "c82a7b40ed1497f5507a7479311e4b3fbd7e4320"
  license "Apache-2.0"
  head "https:github.commesherymeshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ba1b05e8119c53ca254ad1a61a4f24c14d939e0a1c23465e9b161fa2d6602370"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ba1b05e8119c53ca254ad1a61a4f24c14d939e0a1c23465e9b161fa2d6602370"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ba1b05e8119c53ca254ad1a61a4f24c14d939e0a1c23465e9b161fa2d6602370"
    sha256 cellar: :any_skip_relocation, sonoma:        "7d8f52e92c97e6882bcfc1fe84ce84d90f41e3d6f9ec02f3bb8f951b3cddb388"
    sha256 cellar: :any_skip_relocation, ventura:       "7d8f52e92c97e6882bcfc1fe84ce84d90f41e3d6f9ec02f3bb8f951b3cddb388"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d9f5d62c4615373081203f578a0bdd0f65c55c44f1f5343afac2b8495ca0ef9"
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