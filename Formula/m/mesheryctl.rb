class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.8.87",
      revision: "5ab6dabc14f44b8e35693f589deb4242a6eb8d39"
  license "Apache-2.0"
  head "https:github.commesherymeshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "75923b81cc0233cb2796b00a00b0c5442004f82cc9f46a2739db3562248a4f2a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "75923b81cc0233cb2796b00a00b0c5442004f82cc9f46a2739db3562248a4f2a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "75923b81cc0233cb2796b00a00b0c5442004f82cc9f46a2739db3562248a4f2a"
    sha256 cellar: :any_skip_relocation, sonoma:        "e97c60df520b586a046d753bc943c0caabe437d54c17760ccc3cf741a4ae8bc6"
    sha256 cellar: :any_skip_relocation, ventura:       "e97c60df520b586a046d753bc943c0caabe437d54c17760ccc3cf741a4ae8bc6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a25d6b773e9a28f2d5d2d827623706827fef9cb4d1a1afded78509990d95771e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c92290c505896c19c695369ad19463856abcfafc347a25cdf7205b6be3be78ea"
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