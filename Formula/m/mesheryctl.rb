class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.8.138",
      revision: "dcd3e9a702815225888a1367e31e4ca7dc4d0967"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a3d5ea9083dbcdbb51cf8f2d7403009f702fa82e064bcc1ac6debaf1c106e32f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a3d5ea9083dbcdbb51cf8f2d7403009f702fa82e064bcc1ac6debaf1c106e32f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a3d5ea9083dbcdbb51cf8f2d7403009f702fa82e064bcc1ac6debaf1c106e32f"
    sha256 cellar: :any_skip_relocation, sonoma:        "05a3b615ddcf3beaaa85096e80b628d9813a5e5425c81cac669f17a00670d0c0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "156fe7ef3791383486cb82e818316fbdc407ee8ab54ccbc403309ea45908afb6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "471b3a49c7fe078a64a2aae879a8caf8cec4b0652c4acbb338cd8b38a170f7d7"
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