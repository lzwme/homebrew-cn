class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.113",
      revision: "5495658b994ea8198355655fd60b9e25a47b0a96"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f82172469e136d4ed428e424c724a8723a9013ff9e3da8f88ae21ca1af0fddd4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f82172469e136d4ed428e424c724a8723a9013ff9e3da8f88ae21ca1af0fddd4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f82172469e136d4ed428e424c724a8723a9013ff9e3da8f88ae21ca1af0fddd4"
    sha256 cellar: :any_skip_relocation, ventura:        "d8b840c08f00e51f6657cebc76e1deace9fd14397ddc2ea4dd9ce47f6c87ea8a"
    sha256 cellar: :any_skip_relocation, monterey:       "d8b840c08f00e51f6657cebc76e1deace9fd14397ddc2ea4dd9ce47f6c87ea8a"
    sha256 cellar: :any_skip_relocation, big_sur:        "d8b840c08f00e51f6657cebc76e1deace9fd14397ddc2ea4dd9ce47f6c87ea8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e70cf95d55488552d0f1f1781fc313651f6f7a1134339ea6576ee125314e2936"
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