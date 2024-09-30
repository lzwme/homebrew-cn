class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.7.109",
      revision: "2f9930fb2c64eafc5cc5430b6217d391f7a971d1"
  license "Apache-2.0"
  head "https:github.commesherymeshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "80265aaae3a4285c813e97000f20aa3a4e4354c479fa2d26ce3faed12fd09750"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "80265aaae3a4285c813e97000f20aa3a4e4354c479fa2d26ce3faed12fd09750"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "80265aaae3a4285c813e97000f20aa3a4e4354c479fa2d26ce3faed12fd09750"
    sha256 cellar: :any_skip_relocation, sonoma:        "dd3eb85c1737af0958cdb472f6075e35fd377b94cde6738b3000588977a74d67"
    sha256 cellar: :any_skip_relocation, ventura:       "dd3eb85c1737af0958cdb472f6075e35fd377b94cde6738b3000588977a74d67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e3555ee783dddc8f34853a106c6f4ae6ef432f679edf0415c950ec9fd16acdc6"
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