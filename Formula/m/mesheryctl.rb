class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.7.138",
      revision: "604d6c56b34319f24f4d0bc4ac35c6a3c641ff1c"
  license "Apache-2.0"
  head "https:github.commesherymeshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2dcd9bbf1cdcea4fee8e6145949992a5671bc0acecda5e0f4d9d9b2db05045a1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2dcd9bbf1cdcea4fee8e6145949992a5671bc0acecda5e0f4d9d9b2db05045a1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2dcd9bbf1cdcea4fee8e6145949992a5671bc0acecda5e0f4d9d9b2db05045a1"
    sha256 cellar: :any_skip_relocation, sonoma:        "699b8ab11995f2b1769e8870470a2622a0f977c9f558f03c0c695c533ae4f7e5"
    sha256 cellar: :any_skip_relocation, ventura:       "699b8ab11995f2b1769e8870470a2622a0f977c9f558f03c0c695c533ae4f7e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fa4e8a75b8365355d787ba5583e5e0dbf961a8efe79fd8b3917ca265bdea17ae"
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