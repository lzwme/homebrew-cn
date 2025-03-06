class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.8.44",
      revision: "70a581f7312c7979275884e9081f45f0a709daef"
  license "Apache-2.0"
  head "https:github.commesherymeshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "730ab5861a55917ad6a81342d04976a18c724420f365f20dab175d6c9f200c7b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "730ab5861a55917ad6a81342d04976a18c724420f365f20dab175d6c9f200c7b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "730ab5861a55917ad6a81342d04976a18c724420f365f20dab175d6c9f200c7b"
    sha256 cellar: :any_skip_relocation, sonoma:        "8bdc7b8f3a76af24432066a6ad7c0006e8638ee0c2ed96b7e364cd6a30b4d0a6"
    sha256 cellar: :any_skip_relocation, ventura:       "8bdc7b8f3a76af24432066a6ad7c0006e8638ee0c2ed96b7e364cd6a30b4d0a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cf8e5a7c974730517d8fa1b39369599fd2d7e04ed5365288bc1d10ecd34deab0"
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