class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.7.70",
      revision: "b9dba03eb87842580091a172459bbab9fadc1bba"
  license "Apache-2.0"
  head "https:github.commesherymeshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1060944030dbdefb5d10fac71e48b752a3677d0eea1611c6ce55572e16ffcc2c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1060944030dbdefb5d10fac71e48b752a3677d0eea1611c6ce55572e16ffcc2c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1060944030dbdefb5d10fac71e48b752a3677d0eea1611c6ce55572e16ffcc2c"
    sha256 cellar: :any_skip_relocation, sonoma:         "11ce1a1a411b1c178510d8b24791b15a75f102d92018d0713eb0208e4080f324"
    sha256 cellar: :any_skip_relocation, ventura:        "11ce1a1a411b1c178510d8b24791b15a75f102d92018d0713eb0208e4080f324"
    sha256 cellar: :any_skip_relocation, monterey:       "11ce1a1a411b1c178510d8b24791b15a75f102d92018d0713eb0208e4080f324"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "44ae444d66afaf31d21127755eadc4894de7b744cf7cdff2477f1f5aaa1a54d1"
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