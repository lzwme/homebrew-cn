class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v1.0.63",
      revision: "5a287760b1e2fe4f80f99beea108da167ccacf01"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a891536b076706696af79d94d5db6791b086481ea1897e38f4379e27e089f661"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "618b50fcacfb884b77adc44329684f79730ff78796cc4794e1f125ee93710e54"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c17dc72736746a2bb45ea705826ccfb94f8030bf26b0626f2427d4383ce9db1c"
    sha256 cellar: :any_skip_relocation, sonoma:        "4e063a8eefa9cb6fa23e07fb738ca6c42f8e3c7b5c2eb48c88ed24f474642842"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3095727c4f9a88c3e71d2c8b0e946b3a143cc3add9d027127e3129105c2be56e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b8810f2828784de33f6df667beacd5ec5d0e5a585e828bca10d939b6962be8e9"
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