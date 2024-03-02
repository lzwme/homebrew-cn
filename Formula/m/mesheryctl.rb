class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.7.26",
      revision: "0174730455f8606d1e7637bdd39ed8ada9bd50a1"
  license "Apache-2.0"
  head "https:github.commesherymeshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "626df2c448cd0e7b235db2eed91122e8ce6a6031bae3a6a7e07c3a7530a68ef2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "626df2c448cd0e7b235db2eed91122e8ce6a6031bae3a6a7e07c3a7530a68ef2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "626df2c448cd0e7b235db2eed91122e8ce6a6031bae3a6a7e07c3a7530a68ef2"
    sha256 cellar: :any_skip_relocation, sonoma:         "ebe1a8542944417c5837fedc40983c227edb3eba01c6da0ff22645ff533061ba"
    sha256 cellar: :any_skip_relocation, ventura:        "ebe1a8542944417c5837fedc40983c227edb3eba01c6da0ff22645ff533061ba"
    sha256 cellar: :any_skip_relocation, monterey:       "ebe1a8542944417c5837fedc40983c227edb3eba01c6da0ff22645ff533061ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "93b8b7ffd5fb38a584ce5bc9f46006e45ddd2c61d9f1e4198c5cf9987fa839fa"
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