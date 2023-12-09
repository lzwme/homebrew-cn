class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.7.0",
      revision: "3dc6c2b17d8a0e35c7ff08042c93e26fa6b1aa0f"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5a47fcc5e2eaf868e244cf83eefdfb8a9b6c29ef6a2dbf5b2602770a55285da4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5a47fcc5e2eaf868e244cf83eefdfb8a9b6c29ef6a2dbf5b2602770a55285da4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5a47fcc5e2eaf868e244cf83eefdfb8a9b6c29ef6a2dbf5b2602770a55285da4"
    sha256 cellar: :any_skip_relocation, sonoma:         "2de73d33e3fb541a9734629eecf2379e5f84cdb1f749f68bcbd479c489da15ad"
    sha256 cellar: :any_skip_relocation, ventura:        "2de73d33e3fb541a9734629eecf2379e5f84cdb1f749f68bcbd479c489da15ad"
    sha256 cellar: :any_skip_relocation, monterey:       "2de73d33e3fb541a9734629eecf2379e5f84cdb1f749f68bcbd479c489da15ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "abf31889bd2ed1ee89f4f226f60f594a376a0abab9d8361f8c9d76b5df1cc17d"
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