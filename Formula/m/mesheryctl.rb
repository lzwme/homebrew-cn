class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.8.111",
      revision: "cf8a6790015c2e0847b42dbea0c0d49b338ebb3c"
  license "Apache-2.0"
  head "https:github.commesherymeshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "629a424fca636103d4a16c28334ae9c763b3052fb8fb385960132055afcb8374"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "629a424fca636103d4a16c28334ae9c763b3052fb8fb385960132055afcb8374"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "629a424fca636103d4a16c28334ae9c763b3052fb8fb385960132055afcb8374"
    sha256 cellar: :any_skip_relocation, sonoma:        "232f50e374ac72d45492ce3a98b3b362a04c6e66653eb7ef5e3d34b5ae20e1d4"
    sha256 cellar: :any_skip_relocation, ventura:       "232f50e374ac72d45492ce3a98b3b362a04c6e66653eb7ef5e3d34b5ae20e1d4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1ce0cd36f59a2fc958e411ffbd720fdf78fbdd9f0fa1d223382179ff17a9ad72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8edff5cf3397edd9ef8645ec4961ed0b2105571fc7a0bd2cdbcf62af49b64dcf"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"

    ldflags = %W[
      -s -w
      -X github.commesherymesherymesheryctlinternalclirootconstants.version=v#{version}
      -X github.commesherymesherymesheryctlinternalclirootconstants.commitsha=#{Utils.git_short_head}
      -X github.commesherymesherymesheryctlinternalclirootconstants.releasechannel=stable
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