class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.7.59",
      revision: "0176819f44c6927f859ab32f5741f1cfd589b8e3"
  license "Apache-2.0"
  head "https:github.commesherymeshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8b17af5096045c92022fa2d0df1518036d8602cece4b2dbca2c216d42aba12fe"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8b17af5096045c92022fa2d0df1518036d8602cece4b2dbca2c216d42aba12fe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8b17af5096045c92022fa2d0df1518036d8602cece4b2dbca2c216d42aba12fe"
    sha256 cellar: :any_skip_relocation, sonoma:         "9a1b2032a42a8cd73f0b25e778922c469c61c8059b1eceb8677b07523734acd3"
    sha256 cellar: :any_skip_relocation, ventura:        "9a1b2032a42a8cd73f0b25e778922c469c61c8059b1eceb8677b07523734acd3"
    sha256 cellar: :any_skip_relocation, monterey:       "9a1b2032a42a8cd73f0b25e778922c469c61c8059b1eceb8677b07523734acd3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ad69a2b9c72fd42f641644af24161777f5b9b3e87c91d02aaaa7c78c0db2f443"
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