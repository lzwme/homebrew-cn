class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v1.0.64",
      revision: "4789dc8b81cc606366e20779ad050f9f0715800f"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a44078ef18db497328f58f63786a9352ad6dd84610471dd34a2bc1d730864caf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cc379a6902eb46756f504d997f82401f31e5a5953963e29319d944260fb1c548"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b4e6edb7077064992183ae5087fe931278613027b40586a6cc44387f84c33f21"
    sha256 cellar: :any_skip_relocation, sonoma:        "8a6b7c097fdc2b0efbacfedd252462dab37b3f95626aff4a86c36f37a8640374"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "216f77212bbd1197ae65f883e7e6abdd10afde7b4fef448389abfabf904c44d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8388e3c3da2e6fa86bfbf044aabc3609db87a6a91905afb93f83becea36e1a99"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0" if OS.linux?

    ldflags = %W[
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