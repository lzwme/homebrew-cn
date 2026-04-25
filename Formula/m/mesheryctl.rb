class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v1.0.12",
      revision: "55158d289ac06ed0175a9004b4870fd0fb8d4f2f"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "55b321649268d261a34ed94c292f8129ac0cd9a8ad47b4de9cbf1453686a21bc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2d2b591bc21c65ca68202d710de7ad5a46dea9f8109fe378e9f20fef2705263e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ebba1309b425e8cb202794e992202f78a33be0985445ac3fccba6122953081cd"
    sha256 cellar: :any_skip_relocation, sonoma:        "36e0e8fd1650572493ca487ae351d664b1188231eb415211825fce64e2dc6f5e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9e9f9806615ddbd3a5c4004e6aaa94b95ca0ddfebc3456d2084193ed9fce66ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d394b6c590661304f3d993c1a9fc159edebfadda50d8191a149a6d6e6c138329"
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