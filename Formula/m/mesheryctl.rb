class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.7.122",
      revision: "db56988ffab0827b4892d2e18cf772437e7a674b"
  license "Apache-2.0"
  head "https:github.commesherymeshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "94fc51781ab5a5fd241ca76aa0e72f75738eaebc7c57f5e7f3d77e6d7c0c5d02"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "94fc51781ab5a5fd241ca76aa0e72f75738eaebc7c57f5e7f3d77e6d7c0c5d02"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "94fc51781ab5a5fd241ca76aa0e72f75738eaebc7c57f5e7f3d77e6d7c0c5d02"
    sha256 cellar: :any_skip_relocation, sonoma:        "67380a93dca6e7cbb42dad1c1f68d8051c5a10c17ddcdfd33d781b6df764a948"
    sha256 cellar: :any_skip_relocation, ventura:       "67380a93dca6e7cbb42dad1c1f68d8051c5a10c17ddcdfd33d781b6df764a948"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "671187333a228adacdd984db29fcab9937985d3b2ce635331566dc95a2048bcc"
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