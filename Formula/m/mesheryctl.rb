class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.7.111",
      revision: "8a0c54b40a432f5cdd05c8b6f47c0dd180625317"
  license "Apache-2.0"
  head "https:github.commesherymeshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c35cd3d4d2e72df789c4ce179bba8d329a212409fec19191e06913a8caea8185"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c35cd3d4d2e72df789c4ce179bba8d329a212409fec19191e06913a8caea8185"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c35cd3d4d2e72df789c4ce179bba8d329a212409fec19191e06913a8caea8185"
    sha256 cellar: :any_skip_relocation, sonoma:        "2d6e2559d2aaf492d643493faa8e810a779e636a099943b7dfe9e4d85770d244"
    sha256 cellar: :any_skip_relocation, ventura:       "2d6e2559d2aaf492d643493faa8e810a779e636a099943b7dfe9e4d85770d244"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "23b6b19483b0fa218f86e19e7e995f6ea10644c76a770f7ab5f32cf4db2c739d"
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