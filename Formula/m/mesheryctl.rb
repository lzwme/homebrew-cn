class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.8.100",
      revision: "8b63a09f63d673fb8c448a9c888ca68fb5557ed7"
  license "Apache-2.0"
  head "https:github.commesherymeshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d2a680c9d242e60e6e01790cdd847fe40053d280442fcd4ba20389a7710520db"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d2a680c9d242e60e6e01790cdd847fe40053d280442fcd4ba20389a7710520db"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d2a680c9d242e60e6e01790cdd847fe40053d280442fcd4ba20389a7710520db"
    sha256 cellar: :any_skip_relocation, sonoma:        "9e8d9fd0a321f2a99af4c383df769109f099d7c9867f304845779af4802cb25a"
    sha256 cellar: :any_skip_relocation, ventura:       "9e8d9fd0a321f2a99af4c383df769109f099d7c9867f304845779af4802cb25a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "128b6e9802257fa51c52e01fed035656368df42e1b5dec51c1a2dc9b298ba9ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0aed273f3fcd756d932655f5e03c9856c423ef551b073b45f0fd3a234d03c3c7"
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