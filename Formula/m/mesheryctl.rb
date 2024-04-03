class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.7.41",
      revision: "f5c838076affddbd96f644c458ea2a2eb2fcbbd2"
  license "Apache-2.0"
  head "https:github.commesherymeshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3d5f028a7449705fd3b42aded3ebd1aaba85ce3ff33fe3eeefaf214ddf2df205"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3d5f028a7449705fd3b42aded3ebd1aaba85ce3ff33fe3eeefaf214ddf2df205"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3d5f028a7449705fd3b42aded3ebd1aaba85ce3ff33fe3eeefaf214ddf2df205"
    sha256 cellar: :any_skip_relocation, sonoma:         "d21a0c99db5d220ff4f6b6c9e92dfd1a2d2ed400e087d52bb85ee9513f30f81c"
    sha256 cellar: :any_skip_relocation, ventura:        "d21a0c99db5d220ff4f6b6c9e92dfd1a2d2ed400e087d52bb85ee9513f30f81c"
    sha256 cellar: :any_skip_relocation, monterey:       "d21a0c99db5d220ff4f6b6c9e92dfd1a2d2ed400e087d52bb85ee9513f30f81c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e67daecb499c15477f1a980f08359b6789b28833b75baf02743ee718e70b6165"
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