class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.8.37",
      revision: "d15be6fa5c53f9e7762ae805ed914d7a31242a06"
  license "Apache-2.0"
  head "https:github.commesherymeshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0e1302012178e0a9dfe746a04d256122099ad3f816ff3226e32c312f41267a95"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0e1302012178e0a9dfe746a04d256122099ad3f816ff3226e32c312f41267a95"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0e1302012178e0a9dfe746a04d256122099ad3f816ff3226e32c312f41267a95"
    sha256 cellar: :any_skip_relocation, sonoma:        "a6ce640f00e33ec80a72b2cf0adcf86eba105f7b49531ec56fab2e3f4038a42b"
    sha256 cellar: :any_skip_relocation, ventura:       "a6ce640f00e33ec80a72b2cf0adcf86eba105f7b49531ec56fab2e3f4038a42b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e89c75e6e13e6ca63a0236669034f975d9fa21fa96abb979ff28e985c07a413c"
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