class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.7.160",
      revision: "2b95fc9b4ef0758e9ac65f0e269758bc677a5cbc"
  license "Apache-2.0"
  head "https:github.commesherymeshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5df246c52eeedb1a9190976923c102cc001f537e76898d0dd8187c9937a3f6d4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5df246c52eeedb1a9190976923c102cc001f537e76898d0dd8187c9937a3f6d4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5df246c52eeedb1a9190976923c102cc001f537e76898d0dd8187c9937a3f6d4"
    sha256 cellar: :any_skip_relocation, sonoma:        "6eae83cb959011b4aee92702462b8a821d9a78f6ba394cd965e7ea58986d5412"
    sha256 cellar: :any_skip_relocation, ventura:       "6eae83cb959011b4aee92702462b8a821d9a78f6ba394cd965e7ea58986d5412"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4a2dad2ed44bd079333f363829879e6cc9b7a26dc903b3cd585b86c2d08ae09c"
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