class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v1.0.8",
      revision: "1a1984296c8c673a96d9b5fb153c45279944821a"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ffe77f42c463327d94596b85335c0f2bb413377d7902e299b8cb237f92648580"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eed65e9147af7ef22ed87dcc7f6b8daf2cb434cb7888721441c2d6271da155f5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d86dfc65b59fef1be2777aa9dc17940e94433b05a6c7e05ffc3aef6c0e5f25a7"
    sha256 cellar: :any_skip_relocation, sonoma:        "16421e45d7e75d5d3f9d8b560ca10f80491f2dbe6bb15e78227214af542dad91"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "893ac70b0e272a360f10f2385709782c395134356cbc3338240c9481bedd6406"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cb8ecf1da5bc6caf007f2103a3a9e0aaa6ccd09ee79947f91009da44c8e81e21"
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