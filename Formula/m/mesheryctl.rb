class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.7.5",
      revision: "439925c742f1049c10650d5d26fcaa41eb6d1831"
  license "Apache-2.0"
  head "https:github.commesherymeshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "262889966e3cfe6d382145f455c44042532f17e4819cfea87cbe157cd9657ea8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "262889966e3cfe6d382145f455c44042532f17e4819cfea87cbe157cd9657ea8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "262889966e3cfe6d382145f455c44042532f17e4819cfea87cbe157cd9657ea8"
    sha256 cellar: :any_skip_relocation, sonoma:         "0c9082344dda1161e3b0a3bf3ef619c186624a4493a74cb52322c1df22a137b0"
    sha256 cellar: :any_skip_relocation, ventura:        "0c9082344dda1161e3b0a3bf3ef619c186624a4493a74cb52322c1df22a137b0"
    sha256 cellar: :any_skip_relocation, monterey:       "0c9082344dda1161e3b0a3bf3ef619c186624a4493a74cb52322c1df22a137b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "602a44cebc3ab4acc5b8b0d9eac320c41f8b04c27ffd829def882f3b39002f2f"
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