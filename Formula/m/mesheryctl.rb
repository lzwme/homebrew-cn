class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.7.53",
      revision: "38676569ff597d2ae6c23e5940017e20443cda6f"
  license "Apache-2.0"
  head "https:github.commesherymeshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8eecab71a35ede349b7fded6db5ad0b1557b22d0fe3ffa8da5d8d04d4fe79a70"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8eecab71a35ede349b7fded6db5ad0b1557b22d0fe3ffa8da5d8d04d4fe79a70"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8eecab71a35ede349b7fded6db5ad0b1557b22d0fe3ffa8da5d8d04d4fe79a70"
    sha256 cellar: :any_skip_relocation, sonoma:         "78b47912f811024e918a3a61a09b335f83b8f2d3db9862dd9b3e1a3653193e2c"
    sha256 cellar: :any_skip_relocation, ventura:        "78b47912f811024e918a3a61a09b335f83b8f2d3db9862dd9b3e1a3653193e2c"
    sha256 cellar: :any_skip_relocation, monterey:       "78b47912f811024e918a3a61a09b335f83b8f2d3db9862dd9b3e1a3653193e2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee9b07f2fb6281b8be4f2cd73a43c6539890a7ef146aeb8a3d810673965ab970"
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