class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.8.31",
      revision: "112af9e32416cb05927c6ef351327cfffb5bef5c"
  license "Apache-2.0"
  head "https:github.commesherymeshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "240c6b27ced7c0bbbc70f0538f2073996fc66897924df9b73e1747edf0232065"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "240c6b27ced7c0bbbc70f0538f2073996fc66897924df9b73e1747edf0232065"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "240c6b27ced7c0bbbc70f0538f2073996fc66897924df9b73e1747edf0232065"
    sha256 cellar: :any_skip_relocation, sonoma:        "20d965bbf17f4d83f726b0c9a7a8b9942ee1a82cae3da1a3896a0ea6c42ecacf"
    sha256 cellar: :any_skip_relocation, ventura:       "20d965bbf17f4d83f726b0c9a7a8b9942ee1a82cae3da1a3896a0ea6c42ecacf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6e1f34996f8d38fb8ac7e585e04a2d6df170ccc198ba85b844f3d0582a4366fa"
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