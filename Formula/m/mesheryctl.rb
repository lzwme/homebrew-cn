class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.8.1",
      revision: "5ebcd2fd48fd0d810abdaed32498850eb3b36295"
  license "Apache-2.0"
  head "https:github.commesherymeshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a1832a4fe24211e73139e982c479aab64b061e50a4d8c4e668c6ef0297746bcb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a1832a4fe24211e73139e982c479aab64b061e50a4d8c4e668c6ef0297746bcb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a1832a4fe24211e73139e982c479aab64b061e50a4d8c4e668c6ef0297746bcb"
    sha256 cellar: :any_skip_relocation, sonoma:        "845f5a0783119187d4bcaec8e78f70164a12078910c1ca8eee36a9949faf84da"
    sha256 cellar: :any_skip_relocation, ventura:       "845f5a0783119187d4bcaec8e78f70164a12078910c1ca8eee36a9949faf84da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "02af61853ac4ed1e06b56d793897398adc52dc2a68807befc2e4832fb779ac3b"
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