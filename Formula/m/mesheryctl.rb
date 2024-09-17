class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.7.102",
      revision: "239ae2b449be6563c98b77d67f4883b77804be24"
  license "Apache-2.0"
  head "https:github.commesherymeshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "192af6f65fa1ca39561b847dd19d2ebd896a599fa92a220e55b9959992568c2c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "192af6f65fa1ca39561b847dd19d2ebd896a599fa92a220e55b9959992568c2c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "192af6f65fa1ca39561b847dd19d2ebd896a599fa92a220e55b9959992568c2c"
    sha256 cellar: :any_skip_relocation, sonoma:        "b4f928ec707bf6c68dbcf547b3275efc2e52992c1128a566cd4295b9f17ca608"
    sha256 cellar: :any_skip_relocation, ventura:       "b4f928ec707bf6c68dbcf547b3275efc2e52992c1128a566cd4295b9f17ca608"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cc746c1df3d1bc59b7d187d251b95fcdec62d632e4c1e8dbcd92a27c01ad135e"
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