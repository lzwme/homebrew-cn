class Depot < Formula
  desc "Build your Docker images in the cloud"
  homepage "https://depot.dev/"
  url "https://ghfast.top/https://github.com/depot/cli/archive/refs/tags/v2.102.16.tar.gz"
  sha256 "d29628de40845182440f03a0fd3ba12a441587dea6e14b4bbdbce2914e352064"
  license "MIT"
  head "https://github.com/depot/cli.git", branch: "main"

  # Upstream sometimes creates a tag with a stable version format but does not
  # create a release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5152ed37c952173aee4a0c6cdfb921b79f5c0d100782f6e86076f96a44e097cb"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5152ed37c952173aee4a0c6cdfb921b79f5c0d100782f6e86076f96a44e097cb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5152ed37c952173aee4a0c6cdfb921b79f5c0d100782f6e86076f96a44e097cb"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "1ffd9237798b4967d299ae9fb3fdb317ac5b51b6311dd5fa2b27700e17c05fea"
    sha256 cellar: :any,                 x86_64_linux:      "905e58128a0444c3585266b9e446f725324dc595ad3e64c4b203776df042fbb3"
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