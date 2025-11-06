class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.8.152",
      revision: "b7bdbc4a7d2eba73f74d997996b7ff141d7f146f"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "837caf4a7236b858b74958c19339b16b0a24b3e3475766e5e5e17dadb5e68406"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "837caf4a7236b858b74958c19339b16b0a24b3e3475766e5e5e17dadb5e68406"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "837caf4a7236b858b74958c19339b16b0a24b3e3475766e5e5e17dadb5e68406"
    sha256 cellar: :any_skip_relocation, sonoma:        "ed37baf40d048f16b17f9030a26999cf8fa5ecd753133b728f9eb38a6e5154a7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4f506219322a8e62291b2ba61cc27afa7f26e9095b3ff201199f87a0b0b4020f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2a7ca6877de129f86ab6b806fe74b5d575cac781477edbe8a811f3f13908c65c"
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