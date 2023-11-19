class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.178",
      revision: "d5f0de892692bd3e1b10aa6276578e69d13d73b4"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "592dcce0e8b388491bc5f7d4aff0e8775cd2b53ef9eb60d2984b63ec40b0d5c8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "592dcce0e8b388491bc5f7d4aff0e8775cd2b53ef9eb60d2984b63ec40b0d5c8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "592dcce0e8b388491bc5f7d4aff0e8775cd2b53ef9eb60d2984b63ec40b0d5c8"
    sha256 cellar: :any_skip_relocation, sonoma:         "9547d2efa510ed19b7c446805aa26a53a632aa3fc822acbcc2ca7b6f6c206d47"
    sha256 cellar: :any_skip_relocation, ventura:        "9547d2efa510ed19b7c446805aa26a53a632aa3fc822acbcc2ca7b6f6c206d47"
    sha256 cellar: :any_skip_relocation, monterey:       "9547d2efa510ed19b7c446805aa26a53a632aa3fc822acbcc2ca7b6f6c206d47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d171b56110ca81a9c7fa49bd1f7caa3eb14518d0466ef42e9ec098497c437e3c"
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