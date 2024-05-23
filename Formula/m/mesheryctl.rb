class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.7.61",
      revision: "f758f733b445262863ccbc77de7aaf8705b31d20"
  license "Apache-2.0"
  head "https:github.commesherymeshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cdaca5e544021fbb100da8c2a961d38f28607fc67d390994572494d9b67f7464"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cdaca5e544021fbb100da8c2a961d38f28607fc67d390994572494d9b67f7464"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cdaca5e544021fbb100da8c2a961d38f28607fc67d390994572494d9b67f7464"
    sha256 cellar: :any_skip_relocation, sonoma:         "fd9c8f8d3d65e6dae1d1f8270b0731d59c05e1b583afd810cfc2339bf4808363"
    sha256 cellar: :any_skip_relocation, ventura:        "fd9c8f8d3d65e6dae1d1f8270b0731d59c05e1b583afd810cfc2339bf4808363"
    sha256 cellar: :any_skip_relocation, monterey:       "fd9c8f8d3d65e6dae1d1f8270b0731d59c05e1b583afd810cfc2339bf4808363"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c4005467781b8c4ff4056e49190cd2302958c1b520c4a0183a658d62e3256016"
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