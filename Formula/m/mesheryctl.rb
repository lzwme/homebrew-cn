class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.8.102",
      revision: "dc85e0fdd53d65bf98cd3c0e4f61b2acb0f65087"
  license "Apache-2.0"
  head "https:github.commesherymeshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "54c239c2dea43b9d7df2ac3f587f9bc1f3102d16ecc785286fd19f76f5cea2cd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "54c239c2dea43b9d7df2ac3f587f9bc1f3102d16ecc785286fd19f76f5cea2cd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "54c239c2dea43b9d7df2ac3f587f9bc1f3102d16ecc785286fd19f76f5cea2cd"
    sha256 cellar: :any_skip_relocation, sonoma:        "3166baf0c145d8686793c5e59fdb73d509bee04438534eb692bf78ffffdfb9a6"
    sha256 cellar: :any_skip_relocation, ventura:       "3166baf0c145d8686793c5e59fdb73d509bee04438534eb692bf78ffffdfb9a6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7261241e9f4596a67ed9c951230aacdf4185f83a7490c47fbc14cd6496a410f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9aebffb2c75ef9d6ea4e2708c41a0277b38cf98ed2664f087d55d6f013846769"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"

    ldflags = %W[
      -s -w
      -X github.commesherymesherymesheryctlinternalclirootconstants.version=v#{version}
      -X github.commesherymesherymesheryctlinternalclirootconstants.commitsha=#{Utils.git_short_head}
      -X github.commesherymesherymesheryctlinternalclirootconstants.releasechannel=stable
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