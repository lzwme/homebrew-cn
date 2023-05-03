class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.87",
      revision: "272a96408e5b64f761159bb9cb629bd61501635b"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "52ffdedf00940c06176e7561e2251d4051360473152660f19dcc1ff6d6d96e11"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "52ffdedf00940c06176e7561e2251d4051360473152660f19dcc1ff6d6d96e11"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "512fa7922b36993b3f3657b9b05759bcd50cd0fa1a4c0754f64337995b952590"
    sha256 cellar: :any_skip_relocation, ventura:        "6e5f51034981f9165464a790c85ee18f6e3fa9b152f9491ab3eea5e9a5915d9c"
    sha256 cellar: :any_skip_relocation, monterey:       "ebbb66e288c9a17f0652cfba005664bf5372a1385aaae5f8ac353d46991e1b94"
    sha256 cellar: :any_skip_relocation, big_sur:        "6e5f51034981f9165464a790c85ee18f6e3fa9b152f9491ab3eea5e9a5915d9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ae2ed31cb12479d00054ae6660f24dc6c3eb9d2bb619f0578ce393e9bcc56ad2"
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