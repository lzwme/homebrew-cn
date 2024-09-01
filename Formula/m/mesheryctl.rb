class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.7.90",
      revision: "87dd18664cbb9f19040e56e372a528e7532dad33"
  license "Apache-2.0"
  head "https:github.commesherymeshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "63d4597a0bb5ac3b3dcb68d964c52c04cf752bda007eb789839bb504e199a640"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "63d4597a0bb5ac3b3dcb68d964c52c04cf752bda007eb789839bb504e199a640"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "63d4597a0bb5ac3b3dcb68d964c52c04cf752bda007eb789839bb504e199a640"
    sha256 cellar: :any_skip_relocation, sonoma:         "73cbc884400f2035b3467b20fab257dcdcd79c2969f917568d7b81299a1f31ad"
    sha256 cellar: :any_skip_relocation, ventura:        "73cbc884400f2035b3467b20fab257dcdcd79c2969f917568d7b81299a1f31ad"
    sha256 cellar: :any_skip_relocation, monterey:       "73cbc884400f2035b3467b20fab257dcdcd79c2969f917568d7b81299a1f31ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9ff4698311863c44d008b99c761b6c779b565fec91bab4be837bb43eb9c8f04e"
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