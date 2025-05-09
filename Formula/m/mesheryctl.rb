class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.8.76",
      revision: "b4f292ecd4e8e4bebc8ee13eef440c25296fbb8e"
  license "Apache-2.0"
  head "https:github.commesherymeshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fe15e492d71199ac2523df810a2e144792f83aafc56274beeaabf9933767e970"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fe15e492d71199ac2523df810a2e144792f83aafc56274beeaabf9933767e970"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fe15e492d71199ac2523df810a2e144792f83aafc56274beeaabf9933767e970"
    sha256 cellar: :any_skip_relocation, sonoma:        "fa00aae4f1d3be816f07a2231a3c0d7b494fa1e4c0f943ff54ba72a78c787af7"
    sha256 cellar: :any_skip_relocation, ventura:       "fa00aae4f1d3be816f07a2231a3c0d7b494fa1e4c0f943ff54ba72a78c787af7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "de1751923dee046da4a77b782186480ade32542cc8854c5823fe033908cd416b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a783d1584cb9182bd60766a8590e895b915d331b58e91c4fae48d7c6817d9012"
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