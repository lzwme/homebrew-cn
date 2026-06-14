class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v1.0.43",
      revision: "8dd34747d42ec339669a1618e7f1dd34038c21bc"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2690d1b96cf91a5af9d8841da32fc103f769e2c865821f9d628bde24d718055b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7032a538ef33fc39af732a1b8ae97617e6c29b767360a3eeecf6eed783d4a082"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6242983c1a5804763faf765124518b02e3e7003df67e82770bc3da36163c4114"
    sha256 cellar: :any_skip_relocation, sonoma:        "4706bc39cc3032251aed879c2d0fecb85e1c6bf9eced31759b0abb6e7ca0b0f1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "de46d7b16a7b379492033451cd80188f1a4153b368d8306663ae7d76227350b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8f5d40ab4d583e7447027cc9aa72a7d0c6e268da48ea48f68a209c590f17665e"
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