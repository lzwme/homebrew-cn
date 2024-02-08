class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.7.17",
      revision: "5c7409cc17eb0913073243e0fca2b16c5b9b7f37"
  license "Apache-2.0"
  head "https:github.commesherymeshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1605ae9e7b6fe4fe1c249a35a916ce0ed4b138451662da7d0cab7c4a83059aec"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1605ae9e7b6fe4fe1c249a35a916ce0ed4b138451662da7d0cab7c4a83059aec"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1605ae9e7b6fe4fe1c249a35a916ce0ed4b138451662da7d0cab7c4a83059aec"
    sha256 cellar: :any_skip_relocation, sonoma:         "f69b6c54c5d9f02700c9ace70563b0235f75b4a1c780e000098fd2052117e5e5"
    sha256 cellar: :any_skip_relocation, ventura:        "f69b6c54c5d9f02700c9ace70563b0235f75b4a1c780e000098fd2052117e5e5"
    sha256 cellar: :any_skip_relocation, monterey:       "f69b6c54c5d9f02700c9ace70563b0235f75b4a1c780e000098fd2052117e5e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3e8edd4c8786ea54df8e122dccd9165ce2ba722018ea37878ac3993e82c53b8a"
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