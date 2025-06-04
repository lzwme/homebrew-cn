class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.8.96",
      revision: "063613ec41e1c6477635d502f69052271882801c"
  license "Apache-2.0"
  head "https:github.commesherymeshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4c4c6a924e8b31d0e991b5e5652a4751d45ef0f41ffb59e4edf32d57501ed656"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4c4c6a924e8b31d0e991b5e5652a4751d45ef0f41ffb59e4edf32d57501ed656"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4c4c6a924e8b31d0e991b5e5652a4751d45ef0f41ffb59e4edf32d57501ed656"
    sha256 cellar: :any_skip_relocation, sonoma:        "b7bf1ec14de61145dbfe3aa25064f0e5dd8d5e0535714416cdf60b2deefc78e7"
    sha256 cellar: :any_skip_relocation, ventura:       "b7bf1ec14de61145dbfe3aa25064f0e5dd8d5e0535714416cdf60b2deefc78e7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5ee999b62266420d01045cacae46fb082513b1dbebcb846d65c430213702da9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8a1bdd67909668d46fa83796db361b9b1c7eb3ec5bf7840bef9298ada63c22be"
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