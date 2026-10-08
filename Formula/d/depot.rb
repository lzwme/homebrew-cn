class Depot < Formula
  desc "Build your Docker images in the cloud"
  homepage "https://depot.dev/"
  url "https://ghfast.top/https://github.com/depot/cli/archive/refs/tags/v2.102.17.tar.gz"
  sha256 "727165b5f543e6419e14b827b978ed88c0b7ef8b95c6689860e05636abfd6522"
  license "MIT"
  head "https://github.com/depot/cli.git", branch: "main"

  # Upstream sometimes creates a tag with a stable version format but does not
  # create a release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "66b15f3cbe3af9c550b2a20f23882c8bf1edce7941be31b129c97c05f296ea43"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "66b15f3cbe3af9c550b2a20f23882c8bf1edce7941be31b129c97c05f296ea43"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "66b15f3cbe3af9c550b2a20f23882c8bf1edce7941be31b129c97c05f296ea43"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "76efc6267a54ceb9ad580792e657f259b5a9c12e398e7afaff8d139058f20da0"
    sha256 cellar: :any,                 x86_64_linux:      "486024de05b610b702e683a03ccb51e3313d9e55601c448939d636f5cf4da704"
  end

  depends_on "go" => :build

  # Fix linking on Linux arm64 with Go 1.27, which rejects cpuid 2.0.4's linkname to `runtime.sched_getaffinity`.
  patch do
    url "https://github.com/depot/cli/commit/627f8a6dfad7e7f2f33c774d3aa22af9884f0ebb.patch?full_index=1"
    sha256 "bffa3eaea34bebeeb3c27fb9ed326137b8824a1ded170eeeb2cdd91c30dd48ac"
    type :unofficial
    resolves "https://github.com/depot/cli/pull/570"
  end

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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