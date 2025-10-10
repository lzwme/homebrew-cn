class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.8.137",
      revision: "10473976277a8e31a1750de2cb56960552316f9e"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6196baf4f67b2a2a6566f07d00e4611e62b9e0cc825c2959a620f34f2190f199"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6196baf4f67b2a2a6566f07d00e4611e62b9e0cc825c2959a620f34f2190f199"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6196baf4f67b2a2a6566f07d00e4611e62b9e0cc825c2959a620f34f2190f199"
    sha256 cellar: :any_skip_relocation, sonoma:        "e7d3f71dfca2f2b1c585b0811705e702b66b3f1dc85a1e064a46a1884c09ee70"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aa4d2e582fbdf1c27feecfd8ec90c0bfb0317848086d14be0206b05243cb0767"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a812f0728af79ad2f9edf98055d10ff9a0b59374fc4b2fe83e54d55af6d10a15"
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