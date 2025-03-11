class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.8.47",
      revision: "e88dd80e28d27350c8fcd6a945f659072e5cb84a"
  license "Apache-2.0"
  head "https:github.commesherymeshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "08a8cb94ea2bc52fa6ff2ac381915ea1ce6fcac5a6a7648303786f68f4c204e8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "08a8cb94ea2bc52fa6ff2ac381915ea1ce6fcac5a6a7648303786f68f4c204e8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "08a8cb94ea2bc52fa6ff2ac381915ea1ce6fcac5a6a7648303786f68f4c204e8"
    sha256 cellar: :any_skip_relocation, sonoma:        "f1218d0755b74f214c86e259eb1e20ca7c6f5382d5fe3b5904d51177347a2675"
    sha256 cellar: :any_skip_relocation, ventura:       "f1218d0755b74f214c86e259eb1e20ca7c6f5382d5fe3b5904d51177347a2675"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5fe16ca21f398d9f821679da11bffd6f68b9cab1f402fdee98ce15ac05fa24a8"
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