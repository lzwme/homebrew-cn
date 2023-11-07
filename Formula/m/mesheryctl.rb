class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.172",
      revision: "a6ac39300b20ff6bbbeca8686840b4fde8022297"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "286d8d7a02f3170e6104ae8ce6aeebcf038dec091a6d10570dea649b4ac692b9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "286d8d7a02f3170e6104ae8ce6aeebcf038dec091a6d10570dea649b4ac692b9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "286d8d7a02f3170e6104ae8ce6aeebcf038dec091a6d10570dea649b4ac692b9"
    sha256 cellar: :any_skip_relocation, sonoma:         "bb6e5538d33827f4ffb721b23cb2ecdcfbeb49c453a1b2a0161a7734189f8ceb"
    sha256 cellar: :any_skip_relocation, ventura:        "bb6e5538d33827f4ffb721b23cb2ecdcfbeb49c453a1b2a0161a7734189f8ceb"
    sha256 cellar: :any_skip_relocation, monterey:       "bb6e5538d33827f4ffb721b23cb2ecdcfbeb49c453a1b2a0161a7734189f8ceb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "33ac0058bda3977a9297a659ed89edbf0a04891f1b6b5086d866957ed29e0242"
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