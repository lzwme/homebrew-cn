class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.7.49",
      revision: "3f2c19eb5f90ea522fc2530c40c5807bf22e8c52"
  license "Apache-2.0"
  head "https:github.commesherymeshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b57c62e9a89ef4e912e3db961c6965949975897aab456b0b549d0d21da05e829"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b57c62e9a89ef4e912e3db961c6965949975897aab456b0b549d0d21da05e829"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b57c62e9a89ef4e912e3db961c6965949975897aab456b0b549d0d21da05e829"
    sha256 cellar: :any_skip_relocation, sonoma:         "f13a811c770c5d1f8a3efb652cbad73185b9ef06ee7f25588e6fb60b4fe3ab47"
    sha256 cellar: :any_skip_relocation, ventura:        "f13a811c770c5d1f8a3efb652cbad73185b9ef06ee7f25588e6fb60b4fe3ab47"
    sha256 cellar: :any_skip_relocation, monterey:       "f13a811c770c5d1f8a3efb652cbad73185b9ef06ee7f25588e6fb60b4fe3ab47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "24eb2dba6c0d9a252e2583100f04126a78fe5512d8b31ffeb54202fbfee173c6"
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