class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.7.22",
      revision: "33700b2013ce635268957ade3f790983d205af18"
  license "Apache-2.0"
  head "https:github.commesherymeshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e5bddd5646b97ba8766b45d3ae2bc1486e07f0cc6074b995f4d7a259439ba979"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e5bddd5646b97ba8766b45d3ae2bc1486e07f0cc6074b995f4d7a259439ba979"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e5bddd5646b97ba8766b45d3ae2bc1486e07f0cc6074b995f4d7a259439ba979"
    sha256 cellar: :any_skip_relocation, sonoma:         "bfb6ebb868085d4c4375acf9a76762e765d009895816f6cf8161c5aa4ed8ea6b"
    sha256 cellar: :any_skip_relocation, ventura:        "bfb6ebb868085d4c4375acf9a76762e765d009895816f6cf8161c5aa4ed8ea6b"
    sha256 cellar: :any_skip_relocation, monterey:       "bfb6ebb868085d4c4375acf9a76762e765d009895816f6cf8161c5aa4ed8ea6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d5053914c6f9a98bf5fb0509ae3f678cc15059f2dc58add37d762fae7eaf3188"
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