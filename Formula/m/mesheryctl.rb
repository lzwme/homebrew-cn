class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.7.71",
      revision: "157d74031898492e81922c4bbd1e6c44a77407a8"
  license "Apache-2.0"
  head "https:github.commesherymeshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2426afb7fa17a187e6c1417abd73a9521bf0ed89b2411cf2c9260d1e3c73c30a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2426afb7fa17a187e6c1417abd73a9521bf0ed89b2411cf2c9260d1e3c73c30a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2426afb7fa17a187e6c1417abd73a9521bf0ed89b2411cf2c9260d1e3c73c30a"
    sha256 cellar: :any_skip_relocation, sonoma:         "83bd649b5071e2ed23deb4d606fd0d161bdc4154f397ca49e5f54db86b63963e"
    sha256 cellar: :any_skip_relocation, ventura:        "83bd649b5071e2ed23deb4d606fd0d161bdc4154f397ca49e5f54db86b63963e"
    sha256 cellar: :any_skip_relocation, monterey:       "83bd649b5071e2ed23deb4d606fd0d161bdc4154f397ca49e5f54db86b63963e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "528111bb49e811c08eb02cb90e886089af434acf6cbe4a329b8104f61b9317a7"
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