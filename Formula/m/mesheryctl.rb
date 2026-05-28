class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v1.0.32",
      revision: "61d63904aa546b00c23e8a9ec2543f14c2eea10c"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2fb9a04fe8ce2115ac914d64b79187c3338cadf8580153eab4b65ee221251d8e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a34782dd9657efb07b91af13cfffb358ab98635a07c44cf62c0d4b10abcb8070"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0dabbe890528c24fdcca1cacfabe7b868c2914cf8901df4b31e476cb5d93daec"
    sha256 cellar: :any_skip_relocation, sonoma:        "8f1ea7374eef7c7a36a6588700eba7f23555edc111e58920f112bd42aba780ba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eafe643bc3795c4a0ce2cfca3497f49f88b17954d8fbb61ca73fd1778c91ae0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2775c12b076517a85fc01e8ebb7224207bb9c8e554d5a2611fd924e8fd68682c"
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