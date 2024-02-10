class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.7.18",
      revision: "5d1307e053b52db9343f87e76e3a782124fa735c"
  license "Apache-2.0"
  head "https:github.commesherymeshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d3a78077e30fe673b13b8cd2cf52f7cdee47a8736902a9a612a7373db04b2a1d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d3a78077e30fe673b13b8cd2cf52f7cdee47a8736902a9a612a7373db04b2a1d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d3a78077e30fe673b13b8cd2cf52f7cdee47a8736902a9a612a7373db04b2a1d"
    sha256 cellar: :any_skip_relocation, sonoma:         "a5b2133f2f919550d36b9f7106a41f2fd55b286a2c46d2baaa67bbba8d1edb58"
    sha256 cellar: :any_skip_relocation, ventura:        "a5b2133f2f919550d36b9f7106a41f2fd55b286a2c46d2baaa67bbba8d1edb58"
    sha256 cellar: :any_skip_relocation, monterey:       "a5b2133f2f919550d36b9f7106a41f2fd55b286a2c46d2baaa67bbba8d1edb58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6edf6cde702b4d68b8e49a82c89057b925c2ac65afe3792609a40ad7dcd87664"
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