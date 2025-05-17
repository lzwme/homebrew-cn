class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.8.82",
      revision: "8845e461d0f75bb8e17accf81ad0712812d9ff4a"
  license "Apache-2.0"
  head "https:github.commesherymeshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e235122f710d6756b85f2a50d0ffcc121e7243aab0cdf29c001cbb9e6ead53d7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e235122f710d6756b85f2a50d0ffcc121e7243aab0cdf29c001cbb9e6ead53d7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e235122f710d6756b85f2a50d0ffcc121e7243aab0cdf29c001cbb9e6ead53d7"
    sha256 cellar: :any_skip_relocation, sonoma:        "be63056c94db5cf490d1e4c6fe89277f6aa4be60f9d7679ab580a6cca25eaddf"
    sha256 cellar: :any_skip_relocation, ventura:       "be63056c94db5cf490d1e4c6fe89277f6aa4be60f9d7679ab580a6cca25eaddf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5c28d75f5b1ba282276baaef4de88e611434694f3f4fc3fe14dfd54b7d6aa0ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ac733899f8759e591f57beedaee0c69da82f9e208d6dc69b82ddcbea2229a34"
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