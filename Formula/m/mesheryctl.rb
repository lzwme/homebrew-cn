class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.8.109",
      revision: "10fc0567da98d381e952c5ca7918aa81d6a6d771"
  license "Apache-2.0"
  head "https:github.commesherymeshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b7eb6834e4a0a1ee142c5f2211543e168b25be3d0d933420821029db1c54ad26"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b7eb6834e4a0a1ee142c5f2211543e168b25be3d0d933420821029db1c54ad26"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b7eb6834e4a0a1ee142c5f2211543e168b25be3d0d933420821029db1c54ad26"
    sha256 cellar: :any_skip_relocation, sonoma:        "66936630145b55bdc7677a7cdf61cb24d8e85e6d43d5dff09a6567ba9d0a8427"
    sha256 cellar: :any_skip_relocation, ventura:       "66936630145b55bdc7677a7cdf61cb24d8e85e6d43d5dff09a6567ba9d0a8427"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9f5cacaed042097ceab7c445ba80c10e3be70dd67eebab02db5fec5d2e8feb5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a9e7c964a8f9f3e3338705ca816e5ce28b21cdcf3934af3e3b1918d4c6538ce4"
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