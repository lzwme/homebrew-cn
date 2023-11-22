class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.180",
      revision: "53b75f0eb0256691d91713340266183614c6a78d"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "51afdfbc37e6ddcbf292708d6832fdfb4078a374cfe7acf4265d666245b41bd4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "51afdfbc37e6ddcbf292708d6832fdfb4078a374cfe7acf4265d666245b41bd4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "51afdfbc37e6ddcbf292708d6832fdfb4078a374cfe7acf4265d666245b41bd4"
    sha256 cellar: :any_skip_relocation, sonoma:         "89f7cd316142845a29e39af7f9f1fb7ca3b9a2b8263f62ed1d041541411f05b1"
    sha256 cellar: :any_skip_relocation, ventura:        "89f7cd316142845a29e39af7f9f1fb7ca3b9a2b8263f62ed1d041541411f05b1"
    sha256 cellar: :any_skip_relocation, monterey:       "89f7cd316142845a29e39af7f9f1fb7ca3b9a2b8263f62ed1d041541411f05b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "07a82e58a37fb6bb9b8d3582ea40edf6219bc37ff3787ebba72223d9bd35b285"
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