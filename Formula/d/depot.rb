class Depot < Formula
  desc "Build your Docker images in the cloud"
  homepage "https://depot.dev/"
  url "https://ghfast.top/https://github.com/depot/cli/archive/refs/tags/v2.102.12.tar.gz"
  sha256 "b5e93b416976cc65da6779964b4422e4f373aadcffa6f6304e0d44d114c5acb2"
  license "MIT"
  head "https://github.com/depot/cli.git", branch: "main"

  # Upstream sometimes creates a tag with a stable version format but does not
  # create a release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4f73a485d8176d443e63c90196704c7582daeeebe9f566377c2de026a7429456"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4f73a485d8176d443e63c90196704c7582daeeebe9f566377c2de026a7429456"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4f73a485d8176d443e63c90196704c7582daeeebe9f566377c2de026a7429456"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "6334052c6fc92ccc60d4758e3ba29ac5355cfd1900b555ce084a61ccbbfcfba5"
    sha256 cellar: :any,                 x86_64_linux:      "2e636586795da0d25036ef4d0a21452d697e5422d8d14b0d6d6ceb6bc41a19ef"
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