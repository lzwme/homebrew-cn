class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.7.159",
      revision: "ac4f48beab82cb0c98d21dbe5771e7fdc7a5863d"
  license "Apache-2.0"
  head "https:github.commesherymeshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "67e34a7bcd5299b7760958196bfd01bc5210b16bd892b01e97a0d07eafdde65d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "67e34a7bcd5299b7760958196bfd01bc5210b16bd892b01e97a0d07eafdde65d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "67e34a7bcd5299b7760958196bfd01bc5210b16bd892b01e97a0d07eafdde65d"
    sha256 cellar: :any_skip_relocation, sonoma:        "cedbb17bec39d5de2fefc37db37991e15f6683e0200b176814527d38fd5dea6f"
    sha256 cellar: :any_skip_relocation, ventura:       "cedbb17bec39d5de2fefc37db37991e15f6683e0200b176814527d38fd5dea6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c84a36784b4064412f8a981af3aa8d132c4173403f51d56d26ada6ef0d4f3f69"
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