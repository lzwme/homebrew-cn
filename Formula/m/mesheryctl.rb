class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.7.24",
      revision: "b989872a1203be8ce384120a7c8d83a1b917eaf4"
  license "Apache-2.0"
  head "https:github.commesherymeshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e05f99d5f0eaaee0d2b03b238e16c4a32032f89943d0869a6a4d17a86ceb9d86"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e05f99d5f0eaaee0d2b03b238e16c4a32032f89943d0869a6a4d17a86ceb9d86"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e05f99d5f0eaaee0d2b03b238e16c4a32032f89943d0869a6a4d17a86ceb9d86"
    sha256 cellar: :any_skip_relocation, sonoma:         "63245e2c7046b4bfd9b7cf4f93e19202f65343f4f5a0ddd478731e10817a8cd7"
    sha256 cellar: :any_skip_relocation, ventura:        "63245e2c7046b4bfd9b7cf4f93e19202f65343f4f5a0ddd478731e10817a8cd7"
    sha256 cellar: :any_skip_relocation, monterey:       "63245e2c7046b4bfd9b7cf4f93e19202f65343f4f5a0ddd478731e10817a8cd7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0510f6e7322f12189667965fcbbd7f7cb4a2d40f794257057c3546f25942fbf4"
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

    system "go", "build", *std_go_args(ldflags: ldflags), ".mesheryctlcmdmesheryctl"

    generate_completions_from_executable(bin"mesheryctl", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}mesheryctl version 2>&1")
    assert_match "Channel: stable", shell_output("#{bin}mesheryctl system channel view 2>&1")

    # Test kubernetes error on trying to start meshery
    assert_match "The Kubernetes cluster is not accessible.", shell_output("#{bin}mesheryctl system start 2>&1", 1)
  end
end