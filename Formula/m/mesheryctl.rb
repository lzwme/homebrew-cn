class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.7.75",
      revision: "f8da9cf3424a7aa70702603c261613a237f7d5a6"
  license "Apache-2.0"
  head "https:github.commesherymeshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9404b7977b3dfbbc1000173bf8a9f6ae2c1bcce76d14f17ceab2d08f00d705a7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9404b7977b3dfbbc1000173bf8a9f6ae2c1bcce76d14f17ceab2d08f00d705a7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9404b7977b3dfbbc1000173bf8a9f6ae2c1bcce76d14f17ceab2d08f00d705a7"
    sha256 cellar: :any_skip_relocation, sonoma:         "5b0e28f1f7d5610b23e194bdb7229002276705fe2783664ebbdb95c924c8e78e"
    sha256 cellar: :any_skip_relocation, ventura:        "5b0e28f1f7d5610b23e194bdb7229002276705fe2783664ebbdb95c924c8e78e"
    sha256 cellar: :any_skip_relocation, monterey:       "5b0e28f1f7d5610b23e194bdb7229002276705fe2783664ebbdb95c924c8e78e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a089f5478fdbbda0ba9c9d829aafdd334611d7245ce2742ee0b40069ebae3a7e"
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