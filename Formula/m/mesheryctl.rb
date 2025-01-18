class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.8.16",
      revision: "a50d87da74189fbc4482be1177bb933651351b77"
  license "Apache-2.0"
  head "https:github.commesherymeshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "78ed72417dc5e9ea0e83d98fb8978bf39aa4630e66718aba57f951f170b35a03"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "78ed72417dc5e9ea0e83d98fb8978bf39aa4630e66718aba57f951f170b35a03"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "78ed72417dc5e9ea0e83d98fb8978bf39aa4630e66718aba57f951f170b35a03"
    sha256 cellar: :any_skip_relocation, sonoma:        "928d9216ee20c4c0b330612ad4179b30b82fa9e59d8f70927ff7f1d5e24dfbe7"
    sha256 cellar: :any_skip_relocation, ventura:       "928d9216ee20c4c0b330612ad4179b30b82fa9e59d8f70927ff7f1d5e24dfbe7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f893070946deeb87362efc6da0de9bfa77096be11a63725c15125ff4ae2da6d"
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