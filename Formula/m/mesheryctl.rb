class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.8.168",
      revision: "e13309c8cb74cfd8a2d80ffb29e0cd2c84d23b85"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "02483fd4a66c9012e60210eda0f38e07744d67d7a0f063f94d1af42ec38ef2e7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "02483fd4a66c9012e60210eda0f38e07744d67d7a0f063f94d1af42ec38ef2e7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "02483fd4a66c9012e60210eda0f38e07744d67d7a0f063f94d1af42ec38ef2e7"
    sha256 cellar: :any_skip_relocation, sonoma:        "808201d7ec1eced89ab7b11e6db91247ec3ac950d8bf975cb7972a4d62b42d74"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ee1a53e1c3f54fae34c7048f7337621d4f40b7d38a72484901f6a3861fdff695"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b3fa7481939d60ceb6f39949fa547ac5be25082b90961f21ea254c5812cef2e2"
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