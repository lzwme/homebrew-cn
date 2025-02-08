class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.8.27",
      revision: "95a0b9323ec0d9ffb0ce1f3451fababc29626cd8"
  license "Apache-2.0"
  head "https:github.commesherymeshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f30ee7a2d435b3d99882865c9966bafbb16bdaa68afdbffad60933574e41aad3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f30ee7a2d435b3d99882865c9966bafbb16bdaa68afdbffad60933574e41aad3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f30ee7a2d435b3d99882865c9966bafbb16bdaa68afdbffad60933574e41aad3"
    sha256 cellar: :any_skip_relocation, sonoma:        "ed8e0c807cdac7e672bc988a27392d1a7b4656b5f608b1da13a9602b0fa2b310"
    sha256 cellar: :any_skip_relocation, ventura:       "ed8e0c807cdac7e672bc988a27392d1a7b4656b5f608b1da13a9602b0fa2b310"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0aa22e84385246f2a2356dc5fc79a3051a3c78bf8f38c27b2d90f7e76abbc4c2"
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