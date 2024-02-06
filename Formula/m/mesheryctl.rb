class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.7.16",
      revision: "7d361114a1e7a25ff1803915f4dd5564e4a8f605"
  license "Apache-2.0"
  head "https:github.commesherymeshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c2b7f4ceaf3c0bf499dabb49bbe00fb614602278583479d3dcc002b6ad334b93"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c2b7f4ceaf3c0bf499dabb49bbe00fb614602278583479d3dcc002b6ad334b93"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c2b7f4ceaf3c0bf499dabb49bbe00fb614602278583479d3dcc002b6ad334b93"
    sha256 cellar: :any_skip_relocation, sonoma:         "b49138736448dc3a9dc8cbf7d6e5ac1d2b8344cfaba7dc70dd93e7a7bec719ad"
    sha256 cellar: :any_skip_relocation, ventura:        "b49138736448dc3a9dc8cbf7d6e5ac1d2b8344cfaba7dc70dd93e7a7bec719ad"
    sha256 cellar: :any_skip_relocation, monterey:       "b49138736448dc3a9dc8cbf7d6e5ac1d2b8344cfaba7dc70dd93e7a7bec719ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "afbb2aac9b45751bbb9f0320dcbcc88f38777ca59b975e13cbec9bc1ece54f31"
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