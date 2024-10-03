class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.7.110",
      revision: "592b1e8a8879ced75176da9f0ba4b70c917eee54"
  license "Apache-2.0"
  head "https:github.commesherymeshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d3ddd73977b2abfb29ed51d2e17705dda5be2b8f9988c3d7d6d00d00d70384e8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d3ddd73977b2abfb29ed51d2e17705dda5be2b8f9988c3d7d6d00d00d70384e8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d3ddd73977b2abfb29ed51d2e17705dda5be2b8f9988c3d7d6d00d00d70384e8"
    sha256 cellar: :any_skip_relocation, sonoma:        "d4063bcc8b7d2bc2dea6ed82d84f65f1bf44639d28c20fb9cd6fb0831d279ff3"
    sha256 cellar: :any_skip_relocation, ventura:       "d4063bcc8b7d2bc2dea6ed82d84f65f1bf44639d28c20fb9cd6fb0831d279ff3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "64e8ef4918bbfc671a78c8e06dd8487409cd73ff2aaf6b74145d5fe6a8d085dd"
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