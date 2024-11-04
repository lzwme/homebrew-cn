class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.7.133",
      revision: "4110b56af4a417d24d796410137883e2a690951e"
  license "Apache-2.0"
  head "https:github.commesherymeshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "47338b55523a4a75a27f3be2bee64627384c6d3985cd406a8bb1ee209f80ff97"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "47338b55523a4a75a27f3be2bee64627384c6d3985cd406a8bb1ee209f80ff97"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "47338b55523a4a75a27f3be2bee64627384c6d3985cd406a8bb1ee209f80ff97"
    sha256 cellar: :any_skip_relocation, sonoma:        "73c84335503843399690297ca10d9015b5ef9398ac31b64d769f9fd7ec3a12ca"
    sha256 cellar: :any_skip_relocation, ventura:       "73c84335503843399690297ca10d9015b5ef9398ac31b64d769f9fd7ec3a12ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "468d05744c8a9d5cb6761b91893ec5c2dd310467b42eb34804e01517bdf40432"
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