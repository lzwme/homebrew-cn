class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.8.2",
      revision: "5c42d12a36573948d80fbbf3581c753a19b6c6aa"
  license "Apache-2.0"
  head "https:github.commesherymeshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c83de1f31079f288cb816be37b9d000dae503194c32ee64012b7d12d6ef10cfa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c83de1f31079f288cb816be37b9d000dae503194c32ee64012b7d12d6ef10cfa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c83de1f31079f288cb816be37b9d000dae503194c32ee64012b7d12d6ef10cfa"
    sha256 cellar: :any_skip_relocation, sonoma:        "5f30b41516412ea3f984dee360c69ef324d2fdaa2f719b272d98f6308a3cd425"
    sha256 cellar: :any_skip_relocation, ventura:       "5f30b41516412ea3f984dee360c69ef324d2fdaa2f719b272d98f6308a3cd425"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "adf8f7845bf6e232b0b4c18048c67a936c1231a25f8bdd5d9d11b6bf7788e6bf"
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