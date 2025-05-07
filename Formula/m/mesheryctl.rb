class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.8.72",
      revision: "1b9996e62a3b6eb0df41ca8f2d3b613cc87b1cec"
  license "Apache-2.0"
  head "https:github.commesherymeshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bd8146c1badf70040a7127bd029ee8cf302c11a38305c494e3a1b2deded3fbee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bd8146c1badf70040a7127bd029ee8cf302c11a38305c494e3a1b2deded3fbee"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bd8146c1badf70040a7127bd029ee8cf302c11a38305c494e3a1b2deded3fbee"
    sha256 cellar: :any_skip_relocation, sonoma:        "ee5b84ac93296f459a3997dc594e2fe8943f9cb696a8d2f43634b4ae22a732c2"
    sha256 cellar: :any_skip_relocation, ventura:       "ee5b84ac93296f459a3997dc594e2fe8943f9cb696a8d2f43634b4ae22a732c2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "78e970f3ea0af59eaa44abed30e811b40ae7f08698699f29710bd921519df6e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0411dd70f010826b7c56ec3e5f88f92489c7479767aa1c514a079df6dabd7c55"
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