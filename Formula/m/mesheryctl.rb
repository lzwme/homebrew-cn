class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.7.73",
      revision: "3c39d9a54f15d9bf5c2e703fda01ed98ad9c392a"
  license "Apache-2.0"
  head "https:github.commesherymeshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d57070e8e3539d0a22507b2737c5bd2d7563623cd196faa3f17db842a8827760"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d57070e8e3539d0a22507b2737c5bd2d7563623cd196faa3f17db842a8827760"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d57070e8e3539d0a22507b2737c5bd2d7563623cd196faa3f17db842a8827760"
    sha256 cellar: :any_skip_relocation, sonoma:         "439d2326c7ec0781353bb611b0d43305868eca590a85b1940a603c1eea4b1859"
    sha256 cellar: :any_skip_relocation, ventura:        "439d2326c7ec0781353bb611b0d43305868eca590a85b1940a603c1eea4b1859"
    sha256 cellar: :any_skip_relocation, monterey:       "439d2326c7ec0781353bb611b0d43305868eca590a85b1940a603c1eea4b1859"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7846e250f4f05ba6b416e3ecbead5903d8a322b1a23e7df33c7149a8a46fd3a4"
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