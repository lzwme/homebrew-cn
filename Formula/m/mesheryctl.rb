class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.7.76",
      revision: "1c06212bfb8fed821720760d80c27ceefcfb2b30"
  license "Apache-2.0"
  head "https:github.commesherymeshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "987d048a66d25ecc32f968c5d66664f5af34d158f5958163b52c227c4df2e4f8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "987d048a66d25ecc32f968c5d66664f5af34d158f5958163b52c227c4df2e4f8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "987d048a66d25ecc32f968c5d66664f5af34d158f5958163b52c227c4df2e4f8"
    sha256 cellar: :any_skip_relocation, sonoma:         "48b10b17cb7d18b7769b09d35268e9b1cf7d6fc1143c7ab7e6a9c447242c20c5"
    sha256 cellar: :any_skip_relocation, ventura:        "48b10b17cb7d18b7769b09d35268e9b1cf7d6fc1143c7ab7e6a9c447242c20c5"
    sha256 cellar: :any_skip_relocation, monterey:       "48b10b17cb7d18b7769b09d35268e9b1cf7d6fc1143c7ab7e6a9c447242c20c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "47f4d920d74c522435d07dc387b9a21320628d29627fe4652ae0403d8ce4b292"
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