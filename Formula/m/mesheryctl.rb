class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.7.50",
      revision: "edfed0d13cbc5ed07ad19cb715f6721df559e409"
  license "Apache-2.0"
  head "https:github.commesherymeshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cbbf6e1a3addf484f81abb86d32029858ccebe584e3fed454bb4d20b79f93f50"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cbbf6e1a3addf484f81abb86d32029858ccebe584e3fed454bb4d20b79f93f50"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cbbf6e1a3addf484f81abb86d32029858ccebe584e3fed454bb4d20b79f93f50"
    sha256 cellar: :any_skip_relocation, sonoma:         "4774b1cef6e25a08d26d5d14f9733cd120822f77390a8c7dd1f65e63a7b57248"
    sha256 cellar: :any_skip_relocation, ventura:        "4774b1cef6e25a08d26d5d14f9733cd120822f77390a8c7dd1f65e63a7b57248"
    sha256 cellar: :any_skip_relocation, monterey:       "4774b1cef6e25a08d26d5d14f9733cd120822f77390a8c7dd1f65e63a7b57248"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8644eecac583286f6ab3b384a90cf2d70d46d0745d471347a3aacc5831d6e290"
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