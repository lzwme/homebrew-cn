class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.8.124",
      revision: "24aebfc6f1ed6221c19d385518698167778e40bb"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "82a73adebcb793ee08a30d34d6579a4057fe78dd6b9c042b36e7287a629de50e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "82a73adebcb793ee08a30d34d6579a4057fe78dd6b9c042b36e7287a629de50e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "82a73adebcb793ee08a30d34d6579a4057fe78dd6b9c042b36e7287a629de50e"
    sha256 cellar: :any_skip_relocation, sonoma:        "0683f6bcbdaf4e32288c06ed2275f5649a270255bae8dfc22fd62956fae8b3d0"
    sha256 cellar: :any_skip_relocation, ventura:       "0683f6bcbdaf4e32288c06ed2275f5649a270255bae8dfc22fd62956fae8b3d0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b37ddd8c64f15db7cc64f2faaedc73008906497d28c04793005b4f6300a02529"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "59973cd538edc71bc3880b8d0ea69b26899ff1843cd7fb669cd2ab35458c8bb7"
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