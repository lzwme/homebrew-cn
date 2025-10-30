class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.8.147",
      revision: "c195fb123ab72727077afc97b83f58796a6ec6ba"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fc069da1f38be2e1876d0e952eab69ce6fbbdcb5a79766c1b4c0063413f39410"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fc069da1f38be2e1876d0e952eab69ce6fbbdcb5a79766c1b4c0063413f39410"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fc069da1f38be2e1876d0e952eab69ce6fbbdcb5a79766c1b4c0063413f39410"
    sha256 cellar: :any_skip_relocation, sonoma:        "534eac1674f29c68d078bb6b5384bb5dd2d175806a52f7a68fe2235f47a50d07"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "36f4f38e8b5f6cf179a3f8b5224cf7e8c660faae708724b14b99e3d609b98bc0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "34ab5bc10cea04dbac39e0b50b7aef843f08eb425547533d40bfbc4706d4050f"
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