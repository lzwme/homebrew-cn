class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.7.74",
      revision: "6fe68af18e0fc23461ff012752af980d70eb39b3"
  license "Apache-2.0"
  head "https:github.commesherymeshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6361c4c9bf9a4e4909b186a087370eff349ef4582dd82a6a7c0b529ed542a830"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6361c4c9bf9a4e4909b186a087370eff349ef4582dd82a6a7c0b529ed542a830"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6361c4c9bf9a4e4909b186a087370eff349ef4582dd82a6a7c0b529ed542a830"
    sha256 cellar: :any_skip_relocation, sonoma:         "3dfb80e6c14037288c8664aafaae1d8ade544b80878214ca0d5672dfad7f76ce"
    sha256 cellar: :any_skip_relocation, ventura:        "3dfb80e6c14037288c8664aafaae1d8ade544b80878214ca0d5672dfad7f76ce"
    sha256 cellar: :any_skip_relocation, monterey:       "3dfb80e6c14037288c8664aafaae1d8ade544b80878214ca0d5672dfad7f76ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "05f5774e8069a8d2c3dfd96b3ec7a52086b7c9ba17e58312c303e1ca2c6dd8f3"
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