class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.164",
      revision: "161f875c1fc9389595df99e31eb7eb158204a82a"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "376f5f6fea0c01af516bfcc2d450d811b57a0bdb7cefcb23bf36e9c99e12eb11"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "376f5f6fea0c01af516bfcc2d450d811b57a0bdb7cefcb23bf36e9c99e12eb11"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "376f5f6fea0c01af516bfcc2d450d811b57a0bdb7cefcb23bf36e9c99e12eb11"
    sha256 cellar: :any_skip_relocation, sonoma:         "d5e5dc97fe52426c66b66a4a64398e0a85bb6ba463fb1d584f04fc4b5a1dcaa6"
    sha256 cellar: :any_skip_relocation, ventura:        "d5e5dc97fe52426c66b66a4a64398e0a85bb6ba463fb1d584f04fc4b5a1dcaa6"
    sha256 cellar: :any_skip_relocation, monterey:       "d5e5dc97fe52426c66b66a4a64398e0a85bb6ba463fb1d584f04fc4b5a1dcaa6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e29bd06ec53bb650e3eb9649d114ad67b0cfc15e1c8413a1e5907283e616aab6"
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