class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.8.180",
      revision: "4f46d4020630d27a10faa3fd799bf4e9f505c133"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fd67bfcf0006965fbcc20d042d5893c4a74e4fc9b48b9b4aa288aa9e2434433c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fd67bfcf0006965fbcc20d042d5893c4a74e4fc9b48b9b4aa288aa9e2434433c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fd67bfcf0006965fbcc20d042d5893c4a74e4fc9b48b9b4aa288aa9e2434433c"
    sha256 cellar: :any_skip_relocation, sonoma:        "c06b3cdde9b655469d1fd8a0b29e79d8bf4f59f5d64d6de4aaed5b947170912d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cfa528a0cbc5a32d0d15350fd80a33a3d1295b363f848754d8705efebce42aa2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b1b8b58260149d8bc84b64c2c6f91d620973b42e5059d9ac0d0b40ac0616b3f5"
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