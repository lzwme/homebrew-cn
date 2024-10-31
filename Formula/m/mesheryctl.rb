class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.7.129",
      revision: "efa4f6774ff6223b2d9cb3dbeffd57d0be419c85"
  license "Apache-2.0"
  head "https:github.commesherymeshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5b191c1c8c61c7549302ff6a35fc26668839a72667955db6458e30033d49202e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5b191c1c8c61c7549302ff6a35fc26668839a72667955db6458e30033d49202e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5b191c1c8c61c7549302ff6a35fc26668839a72667955db6458e30033d49202e"
    sha256 cellar: :any_skip_relocation, sonoma:        "6a7d4c96f0dbf945e4848ee92b034dea252887e0ef8f036258fbbe952edd474f"
    sha256 cellar: :any_skip_relocation, ventura:       "6a7d4c96f0dbf945e4848ee92b034dea252887e0ef8f036258fbbe952edd474f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "efa2fce1fb1b69af8c6c76facd9171fc487152a1943e3bc3846b625b5b9b6287"
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