class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.7.45",
      revision: "ecaf02b9c0f6e281190c22ee669e29b6beae70c7"
  license "Apache-2.0"
  head "https:github.commesherymeshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "369553b006b330357741ff82cb207465f4fae09a9e4bd7f0ec67fce0b6e5213a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "369553b006b330357741ff82cb207465f4fae09a9e4bd7f0ec67fce0b6e5213a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "369553b006b330357741ff82cb207465f4fae09a9e4bd7f0ec67fce0b6e5213a"
    sha256 cellar: :any_skip_relocation, sonoma:         "a60ce8c153ad576a6aca129c83d2afba0a301ba4c24e2b53a3f9401cd6838342"
    sha256 cellar: :any_skip_relocation, ventura:        "a60ce8c153ad576a6aca129c83d2afba0a301ba4c24e2b53a3f9401cd6838342"
    sha256 cellar: :any_skip_relocation, monterey:       "a60ce8c153ad576a6aca129c83d2afba0a301ba4c24e2b53a3f9401cd6838342"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9961edf5e3f858e3a859ce6d6f9f26a4112fe1558a86853abec1bd4c1434e239"
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