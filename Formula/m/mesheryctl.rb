class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.165",
      revision: "499d9d84fbfb3bf58868dbbefdfe85105192096d"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "374896f6b1ade46a4b430d90179e49f965c764c5057ea353e020da6dead92ddc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "374896f6b1ade46a4b430d90179e49f965c764c5057ea353e020da6dead92ddc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "374896f6b1ade46a4b430d90179e49f965c764c5057ea353e020da6dead92ddc"
    sha256 cellar: :any_skip_relocation, sonoma:         "c29b7d497417236b4f5e5714522b93c7dc8b443aaa56b9360e1277a3438693da"
    sha256 cellar: :any_skip_relocation, ventura:        "c29b7d497417236b4f5e5714522b93c7dc8b443aaa56b9360e1277a3438693da"
    sha256 cellar: :any_skip_relocation, monterey:       "c29b7d497417236b4f5e5714522b93c7dc8b443aaa56b9360e1277a3438693da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee0930b4859e9fa6b047f4936389a730038596c29729654149b182774c82d34b"
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