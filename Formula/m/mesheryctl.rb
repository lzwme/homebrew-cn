class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.7.84",
      revision: "e88cb109f0bb023e4cce283568249ee5c94ceabb"
  license "Apache-2.0"
  head "https:github.commesherymeshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "469c1e111f896dfc48b97dac5a5c69691b28ed74d1c7ff92ca475ecdb0d22c79"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "469c1e111f896dfc48b97dac5a5c69691b28ed74d1c7ff92ca475ecdb0d22c79"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "469c1e111f896dfc48b97dac5a5c69691b28ed74d1c7ff92ca475ecdb0d22c79"
    sha256 cellar: :any_skip_relocation, sonoma:         "80263b30a971996af72cb0c653c0e626ae4e638ebe103d0edf9e2eb26c0f3c73"
    sha256 cellar: :any_skip_relocation, ventura:        "80263b30a971996af72cb0c653c0e626ae4e638ebe103d0edf9e2eb26c0f3c73"
    sha256 cellar: :any_skip_relocation, monterey:       "80263b30a971996af72cb0c653c0e626ae4e638ebe103d0edf9e2eb26c0f3c73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1fa0089d8c53296d1700c9accc97b3fe45767e599b6442111ace112fd9d71bc4"
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