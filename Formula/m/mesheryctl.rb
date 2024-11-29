class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.7.164",
      revision: "9e1927d15275b4f8cd349bef13efa516a3062135"
  license "Apache-2.0"
  head "https:github.commesherymeshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1f6cb7fff588d1136a0aee62a7002502a42274022d8cdb1b4e5ae5001b8f9983"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1f6cb7fff588d1136a0aee62a7002502a42274022d8cdb1b4e5ae5001b8f9983"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1f6cb7fff588d1136a0aee62a7002502a42274022d8cdb1b4e5ae5001b8f9983"
    sha256 cellar: :any_skip_relocation, sonoma:        "7cbc40df3e454f050dc6a4045276974d6f0fe4cbcad15b3ae4f2ea6fde55dd39"
    sha256 cellar: :any_skip_relocation, ventura:       "7cbc40df3e454f050dc6a4045276974d6f0fe4cbcad15b3ae4f2ea6fde55dd39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f60b77fd148202be8fa450409d3a43c99e9a0d156e3cc74cbd75d54d808c4b8f"
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