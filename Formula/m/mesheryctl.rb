class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.7.152",
      revision: "0062d4ba2956c0cbae5f44d2c713a0d9515cfa0c"
  license "Apache-2.0"
  head "https:github.commesherymeshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "066591b60b9b29c78004ac25c896db61cbcb0bd8b5fdb7a4e5835e3a28547661"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "066591b60b9b29c78004ac25c896db61cbcb0bd8b5fdb7a4e5835e3a28547661"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "066591b60b9b29c78004ac25c896db61cbcb0bd8b5fdb7a4e5835e3a28547661"
    sha256 cellar: :any_skip_relocation, sonoma:        "1d523e825d7a3b540252303c8f4016595aceb52a12aa8430d08621d6f8910ded"
    sha256 cellar: :any_skip_relocation, ventura:       "1d523e825d7a3b540252303c8f4016595aceb52a12aa8430d08621d6f8910ded"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1698d5f87531a526c6ea33d6529a7f68a214f69a69dc89d73511525634938df6"
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