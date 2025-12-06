class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.8.178",
      revision: "b46185f10c57d7d443e9dd1319a20647348c4900"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "40e7dea7f9f3f61f6db30b38c247580f64bb0790fb035745d8b533676e1d0ded"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "40e7dea7f9f3f61f6db30b38c247580f64bb0790fb035745d8b533676e1d0ded"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "40e7dea7f9f3f61f6db30b38c247580f64bb0790fb035745d8b533676e1d0ded"
    sha256 cellar: :any_skip_relocation, sonoma:        "86dca2957cbd76140664e5f5839b63bea787e7827eae13ef4dc59249517d1d80"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "335865ef595bff136bcc3dc6f2614b91681b3734d30804035a262fe3cfd9ee56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8f2de917c8bb4a96af3f39adc1a5f2439f56a6009a67f301e981b7227c557f6b"
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