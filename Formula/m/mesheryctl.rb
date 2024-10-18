class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.7.123",
      revision: "d7f1d7e8d0db5dc48b0a8f78658b136cfb717132"
  license "Apache-2.0"
  head "https:github.commesherymeshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f3e86a0ec73360d89961a512483192497a74474f04f3aa7b0ba821cf6645061f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f3e86a0ec73360d89961a512483192497a74474f04f3aa7b0ba821cf6645061f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f3e86a0ec73360d89961a512483192497a74474f04f3aa7b0ba821cf6645061f"
    sha256 cellar: :any_skip_relocation, sonoma:        "975f2ba01e186cf5404050e32547d422748e9befea10820ca0cb55ef41bad6cf"
    sha256 cellar: :any_skip_relocation, ventura:       "975f2ba01e186cf5404050e32547d422748e9befea10820ca0cb55ef41bad6cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "83893383724e94a915ff76a8c1cc622a2dcae8738386fd1e80da0dfcc35d3aaa"
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