class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.8.143",
      revision: "31470a09af560c6b44f0026057b0985cd052ef92"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fd47635972ef3246df8fd9a2e239f98dc40c68682ac2a39c4f12276ebb9ab04d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fd47635972ef3246df8fd9a2e239f98dc40c68682ac2a39c4f12276ebb9ab04d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fd47635972ef3246df8fd9a2e239f98dc40c68682ac2a39c4f12276ebb9ab04d"
    sha256 cellar: :any_skip_relocation, sonoma:        "9412450fff40bf834c814fb0464adf456c60818a5caf36e12998bdf23cd888c5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "757d792e06488a08254ce3002be90f83da61c6ccbcad433d751a0c15d7d8439b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "16707574d9e64365ec7ad870a171b060d0e95b6c4eb7a5f6872cb41aa7b0f238"
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