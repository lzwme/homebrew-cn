class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.8.28",
      revision: "6ffd9dfe0949d62d8f9a76b54ef99714f7131076"
  license "Apache-2.0"
  head "https:github.commesherymeshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e0d8543886b823ca1000359b10c5c08820e1985cf0d33642cd23b54ce2c51a70"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e0d8543886b823ca1000359b10c5c08820e1985cf0d33642cd23b54ce2c51a70"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e0d8543886b823ca1000359b10c5c08820e1985cf0d33642cd23b54ce2c51a70"
    sha256 cellar: :any_skip_relocation, sonoma:        "c0ac433d0e36b372dbfeb901185527bb81e6f24d5d7cad65d9ab450ffb97e1ae"
    sha256 cellar: :any_skip_relocation, ventura:       "c0ac433d0e36b372dbfeb901185527bb81e6f24d5d7cad65d9ab450ffb97e1ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7db079975573298e9c6069fac76c48ef2d2cf35b9a6aa1564a8fe11ad1564518"
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