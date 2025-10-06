class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.8.135",
      revision: "bacfafa618de36a0886f0d591f4204dbf8c4fd75"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "69ba8d7935ddd9610ef5ce46fed29dcd6b9332c28ec5355b1533ad95d6180e8e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "69ba8d7935ddd9610ef5ce46fed29dcd6b9332c28ec5355b1533ad95d6180e8e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "69ba8d7935ddd9610ef5ce46fed29dcd6b9332c28ec5355b1533ad95d6180e8e"
    sha256 cellar: :any_skip_relocation, sonoma:        "e50a9dd677a7ec29597d9d9c0b2b1867b026b2cbd5dcebb96873bb4493164396"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "238486198fcbcdc23e31a5cabf3371c50998f3b1bd984d27d607d73b52882a21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9872dfd14ac267e8e834128914fc490218a904644edd5cac3aa8d2cfa05212eb"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"

    ldflags = %W[
      -s -w
      -X github.com/meshery/meshery/mesheryctl/internal/cli/root/constants.version=v#{version}
      -X github.com/meshery/meshery/mesheryctl/internal/cli/root/constants.commitsha=#{Utils.git_short_head}
      -X github.com/meshery/meshery/mesheryctl/internal/cli/root/constants.releasechannel=stable
    ]

    system "go", "build", *std_go_args(ldflags:), "./mesheryctl/cmd/mesheryctl"

    generate_completions_from_executable(bin/"mesheryctl", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mesheryctl version 2>&1")
    assert_match "Channel: stable", shell_output("#{bin}/mesheryctl system channel view 2>&1")

    # Test kubernetes error on trying to start meshery
    assert_match "The Kubernetes cluster is not accessible.", shell_output("#{bin}/mesheryctl system start 2>&1", 1)
  end
end