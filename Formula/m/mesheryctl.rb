class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.8.104",
      revision: "388e23a1d98b076b8943b67ce6b4cafe12cc5558"
  license "Apache-2.0"
  head "https:github.commesherymeshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "899a17468b1b009285d261ae4f5bc681dd112c206ae0f565270a6662b556324e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "899a17468b1b009285d261ae4f5bc681dd112c206ae0f565270a6662b556324e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "899a17468b1b009285d261ae4f5bc681dd112c206ae0f565270a6662b556324e"
    sha256 cellar: :any_skip_relocation, sonoma:        "c4be49943bd4f41aba14a545c144051cf3b289a806b6682f197edf6a48f5b765"
    sha256 cellar: :any_skip_relocation, ventura:       "c4be49943bd4f41aba14a545c144051cf3b289a806b6682f197edf6a48f5b765"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "faf5662b415f617ab9db8be2d42863d0151511877eb8d3c670a00d9bd24fb2a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dff5e25755e676bfc61efeed41cce873a6738781f7345bfd28bb08f75635abb2"
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