class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.72",
      revision: "23f8141410b3079f70a633bfade577a3200fb3b4"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a63d8bfd9b74c7f896d4891fd6ae35458ce763bdaf8cd024c1c8ec22ccf9b254"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4c57537587e442726c3eab8c1a03f582f2ee9e701a4f73c26aeb50bc0992c41f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4c57537587e442726c3eab8c1a03f582f2ee9e701a4f73c26aeb50bc0992c41f"
    sha256 cellar: :any_skip_relocation, ventura:        "1b60bb872ff66acdb5af03333b918f36716442930dec60cf3ab51ff22b8f1bce"
    sha256 cellar: :any_skip_relocation, monterey:       "027c89640a4d27f954ef27a9eb80394f351df1cb11c817b97499f073528f7c70"
    sha256 cellar: :any_skip_relocation, big_sur:        "1b60bb872ff66acdb5af03333b918f36716442930dec60cf3ab51ff22b8f1bce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1ee330e42c020f8e183144a1ae62030fecb8c6e3ca9378b4c19d2c5c1fca4153"
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