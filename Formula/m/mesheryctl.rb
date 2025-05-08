class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.8.75",
      revision: "7f1945679d677d6d7baabb9bfc2cd40838a71254"
  license "Apache-2.0"
  head "https:github.commesherymeshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "50c8d9ede27905878df946e8effcefff91c6a9518372d8ad89450dbc0fd4d368"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "50c8d9ede27905878df946e8effcefff91c6a9518372d8ad89450dbc0fd4d368"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "50c8d9ede27905878df946e8effcefff91c6a9518372d8ad89450dbc0fd4d368"
    sha256 cellar: :any_skip_relocation, sonoma:        "9039e89c33e9efa6edec5058b4fea29b7b1a2140c3e14f541acf6ab84da8c864"
    sha256 cellar: :any_skip_relocation, ventura:       "9039e89c33e9efa6edec5058b4fea29b7b1a2140c3e14f541acf6ab84da8c864"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3fdd0c29dfa8b8ac49f84d6f5fd7d2eed03dbe5cac885e919b3be644e18ae397"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "61bfb44dfc446d23480dcc85d14692cf0b7f9ffe9f058141af6fcf7fdb949142"
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