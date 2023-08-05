class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.117",
      revision: "f5b8ec41020b0e7be9badca1f16298d82216920b"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5371657c23aa8b1ac74c6c3d5b981dd9d50efc422bef476aef251cc059af8e1c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5371657c23aa8b1ac74c6c3d5b981dd9d50efc422bef476aef251cc059af8e1c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5371657c23aa8b1ac74c6c3d5b981dd9d50efc422bef476aef251cc059af8e1c"
    sha256 cellar: :any_skip_relocation, ventura:        "a0229567dff704cca2090a1083eb074d9e296df283137297704a231ec0f6b5eb"
    sha256 cellar: :any_skip_relocation, monterey:       "a0229567dff704cca2090a1083eb074d9e296df283137297704a231ec0f6b5eb"
    sha256 cellar: :any_skip_relocation, big_sur:        "a0229567dff704cca2090a1083eb074d9e296df283137297704a231ec0f6b5eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "355147f996617f3fc7aa1d202de5b6a9975edaf452b6622170312b02bad96f85"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"

    ldflags = %W[
      -s -w
      -X github.com/layer5io/meshery/mesheryctl/internal/cli/root/constants.version=v#{version}
      -X github.com/layer5io/meshery/mesheryctl/internal/cli/root/constants.commitsha=#{Utils.git_short_head}
      -X github.com/layer5io/meshery/mesheryctl/internal/cli/root/constants.releasechannel=stable
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./mesheryctl/cmd/mesheryctl"

    generate_completions_from_executable(bin/"mesheryctl", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mesheryctl version 2>&1")
    assert_match "Channel: stable", shell_output("#{bin}/mesheryctl system channel view 2>&1")

    # Test kubernetes error on trying to start meshery
    assert_match "The Kubernetes cluster is not accessible.", shell_output("#{bin}/mesheryctl system start 2>&1", 1)
  end
end