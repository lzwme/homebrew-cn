class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.8.173",
      revision: "2345459378fa7c24f4e44afc37eedf283df6dbdc"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "43a825ef7746e16edff0aec8bce96de27aef5273da6e50400195c27ae3ed4055"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "43a825ef7746e16edff0aec8bce96de27aef5273da6e50400195c27ae3ed4055"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "43a825ef7746e16edff0aec8bce96de27aef5273da6e50400195c27ae3ed4055"
    sha256 cellar: :any_skip_relocation, sonoma:        "4854cfd4fcaeed106fbf963cb4befe7d46feb0d7d78a4df426569e2014ae8712"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "155c4ba2448c829423bb898e940708ff55b4f8e7841ee7a3aeda3ccc76167c30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d804611598564f59b6a6238621af15ab001f41329e567d97e3c9b824f9ee77e3"
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