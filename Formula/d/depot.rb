class Depot < Formula
  desc "Build your Docker images in the cloud"
  homepage "https://depot.dev/"
  url "https://ghfast.top/https://github.com/depot/cli/archive/refs/tags/v2.102.0.tar.gz"
  sha256 "1f59a283bc6577934b86d5a435690d46f236a5124a5af564a06fa2a907c58624"
  license "MIT"
  head "https://github.com/depot/cli.git", branch: "main"

  # Upstream sometimes creates a tag with a stable version format but does not
  # create a release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "beee203578de5617296880936cad8b38caf649649bc7987f689e6ce03723471f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "beee203578de5617296880936cad8b38caf649649bc7987f689e6ce03723471f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "beee203578de5617296880936cad8b38caf649649bc7987f689e6ce03723471f"
    sha256 cellar: :any_skip_relocation, sonoma:        "e7c7e06a2948068a106ce6a6c63455ded196d6ea452d076f1a29758b3f3a95eb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "11c98a1117e8a23fab01f5a1d2eb13be7cb9a9baa4949045996d51b3b1f1ea6d"
    sha256 cellar: :any,                 x86_64_linux:  "a49d9df02316b479498e9ebbb5de7509111c0b124e7e3ef92057ccf588f418f2"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X github.com/depot/cli/internal/build.Version=#{version}
      -X github.com/depot/cli/internal/build.Date=#{time.iso8601}
      -X github.com/depot/cli/internal/build.SentryEnvironment=release
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/depot"

    generate_completions_from_executable(bin/"depot", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/depot --version")
    output = shell_output("#{bin}/depot list builds 2>&1", 1)
    assert_match "unknown project ID", output
  end
end