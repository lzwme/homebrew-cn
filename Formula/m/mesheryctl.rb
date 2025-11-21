class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.8.171",
      revision: "1ab03250be6077e1f8881c635819704e18f653ec"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0ca1113b261134dc82cec27657dfdb28ab3f4f278b86b335f751ce9364f2d601"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0ca1113b261134dc82cec27657dfdb28ab3f4f278b86b335f751ce9364f2d601"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0ca1113b261134dc82cec27657dfdb28ab3f4f278b86b335f751ce9364f2d601"
    sha256 cellar: :any_skip_relocation, sonoma:        "041142ffe291781e5745ace7664df5b3762eb8c2356ddd9db0933a77cdc85328"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "01dcd2972f14d8292a59650d5eeb9570f4806e1d3b48b3eb0b0bd0b0dfab122d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "84e2ff5ec502c9ef5febc183e51e5a0e9b7216950002e6e8718ee3832db39ff8"
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