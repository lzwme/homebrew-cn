class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.7.82",
      revision: "f66c3eff6fb942d43db9fe8a2e2fa0b0ee3522f2"
  license "Apache-2.0"
  head "https:github.commesherymeshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2b0f51cb6fd744aaf74d6215319c426e9987ef4df5ca3e08cc9e02fff4ed5442"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2b0f51cb6fd744aaf74d6215319c426e9987ef4df5ca3e08cc9e02fff4ed5442"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2b0f51cb6fd744aaf74d6215319c426e9987ef4df5ca3e08cc9e02fff4ed5442"
    sha256 cellar: :any_skip_relocation, sonoma:         "551dfe832cb4102d0fd1dffb5cfc9b1c0236f3a00f323e24c710ec4752bc3eab"
    sha256 cellar: :any_skip_relocation, ventura:        "551dfe832cb4102d0fd1dffb5cfc9b1c0236f3a00f323e24c710ec4752bc3eab"
    sha256 cellar: :any_skip_relocation, monterey:       "551dfe832cb4102d0fd1dffb5cfc9b1c0236f3a00f323e24c710ec4752bc3eab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "85498c45b3733c1587c55d64483c6e87d5f973ae6ecb15e5c4435948b7c6faf6"
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