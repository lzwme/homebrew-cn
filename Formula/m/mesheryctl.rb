class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.8.191",
      revision: "810d03e1b7cc6b7f6da4b53e5d6399027b22d4d1"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ebc34c18eca489b264f029060142d2ac8e14888362dde7d6da4ab18469b01deb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e5ad872f0fe6d48098ca5639a23a399303ab4d81d66606a50c1cb5dff106c3a7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "727124cd6430e120b5e038d8fe969545c0634e789f4e9b699bdad5f233b92a0e"
    sha256 cellar: :any_skip_relocation, sonoma:        "c467d0723f8f6ea4adb1be92128fb74bccbcee917158a16b8a8e91a865f03d9e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d4337be4a75c0d4508c3349ab5df8baa5c98c71dcb554d5a1333703bf9875374"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f05398def4a01c6a33b05464e3922114844b0ae69abe2d0d613a886410e08345"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0" if OS.linux?

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