class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.8.50",
      revision: "410d5909221f22b22418cbd0d546ebafd87a51fe"
  license "Apache-2.0"
  head "https:github.commesherymeshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5ee1cdee419e38f9f12e3228191b9733df5ee79c26e62a0f8d5ec2e3f4f8ad15"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5ee1cdee419e38f9f12e3228191b9733df5ee79c26e62a0f8d5ec2e3f4f8ad15"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5ee1cdee419e38f9f12e3228191b9733df5ee79c26e62a0f8d5ec2e3f4f8ad15"
    sha256 cellar: :any_skip_relocation, sonoma:        "de02350c839ac0d1c97ca646bb81889f9d9eacfb730165b8eb7e3ad4fd3fb96a"
    sha256 cellar: :any_skip_relocation, ventura:       "de02350c839ac0d1c97ca646bb81889f9d9eacfb730165b8eb7e3ad4fd3fb96a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "328dd118cdf64d00a266ab8dce0f66c76116e68f37c807085cef6db11c792ff9"
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