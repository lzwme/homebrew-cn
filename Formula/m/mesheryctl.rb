class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.7.134",
      revision: "9caff530a53d66867716a76d99e004533c7feb6b"
  license "Apache-2.0"
  head "https:github.commesherymeshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "038827628fcd69e59e0cf45a6a4500f0b337c6ea98dbac5ef6733fc7cc079dcd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "038827628fcd69e59e0cf45a6a4500f0b337c6ea98dbac5ef6733fc7cc079dcd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "038827628fcd69e59e0cf45a6a4500f0b337c6ea98dbac5ef6733fc7cc079dcd"
    sha256 cellar: :any_skip_relocation, sonoma:        "130f731e72311938912fd6402708061ac0be52b4194224caf0e14f4e663e6d52"
    sha256 cellar: :any_skip_relocation, ventura:       "130f731e72311938912fd6402708061ac0be52b4194224caf0e14f4e663e6d52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "65dc66101362fd98aa617e4aece84969648b28f8cf2b3cf4d23f922b316ecd44"
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