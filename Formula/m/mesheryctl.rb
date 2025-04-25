class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.8.62",
      revision: "41140e7ff736075d3d5cb3863b8e52ef9f4c8149"
  license "Apache-2.0"
  head "https:github.commesherymeshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9f3c2fb46ff3cfcf44fb0b1afad4b6372ed39b38a1195c3b3254a25cbebca136"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9f3c2fb46ff3cfcf44fb0b1afad4b6372ed39b38a1195c3b3254a25cbebca136"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9f3c2fb46ff3cfcf44fb0b1afad4b6372ed39b38a1195c3b3254a25cbebca136"
    sha256 cellar: :any_skip_relocation, sonoma:        "33ae1a4246ac742bef857e9d00f3dbb95283c8674c5f048dff0f68f0ba74e70b"
    sha256 cellar: :any_skip_relocation, ventura:       "33ae1a4246ac742bef857e9d00f3dbb95283c8674c5f048dff0f68f0ba74e70b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a74cd7ac72859406a3e9f746cc3c5d7c62fe1b4e60f86ee665839b7d45bc465e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7df90aac1c2313358378c5b07576cf4bee3b73fc98de6c341e7226aa51bd0442"
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