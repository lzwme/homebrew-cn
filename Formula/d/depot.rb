class Depot < Formula
  desc "Build your Docker images in the cloud"
  homepage "https://depot.dev/"
  url "https://ghfast.top/https://github.com/depot/cli/archive/refs/tags/v2.101.14.tar.gz"
  sha256 "a4bdf4627062ab6e626a7f40203f8296fecfc62d4300fe8c1c43d942b2ea116e"
  license "MIT"
  head "https://github.com/depot/cli.git", branch: "main"

  # Upstream sometimes creates a tag with a stable version format but does not
  # create a release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a37876cdb11961cadf58e032c21cb1cf421ee992e956a3eec82ad7d2cb2da06f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a37876cdb11961cadf58e032c21cb1cf421ee992e956a3eec82ad7d2cb2da06f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a37876cdb11961cadf58e032c21cb1cf421ee992e956a3eec82ad7d2cb2da06f"
    sha256 cellar: :any_skip_relocation, sonoma:        "9c4580c0d7c546316ba8015cc75d65b7c2ff8a97d23f82ed0d19e3c844c058da"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bd0c687d7cea2fafcb93e17dcc68ec40c266160b3a11823e4bbe01015ea6a3b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "09c942bcdbffc21d91ef85b2910564de6ec08c297150f831b6a9f19fc28f5e08"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
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
    assert_match "Error: unknown project ID", output
  end
end