class Depot < Formula
  desc "Build your Docker images in the cloud"
  homepage "https://depot.dev/"
  url "https://ghfast.top/https://github.com/depot/cli/archive/refs/tags/v2.102.24.tar.gz"
  sha256 "6a5bf48d2040a16286b66c0876669f967d7c69a86e497aaab0bb2fc400e625e8"
  license "MIT"
  head "https://github.com/depot/cli.git", branch: "main"

  # Upstream sometimes creates a tag with a stable version format but does not
  # create a release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e1e0651838dd0627a82e107203dca6bc76844ace90607ac0649473d465913f16"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e1e0651838dd0627a82e107203dca6bc76844ace90607ac0649473d465913f16"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e1e0651838dd0627a82e107203dca6bc76844ace90607ac0649473d465913f16"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "13890a225049aed2fd8bd230c7cd098bafcc1196562df6c45a2d3b99bf2a4973"
    sha256 cellar: :any,                 x86_64_linux:      "0f2ca4e0e947f0c4948fe25dac31afe6784412c0b5079ae8a3e4466bdcc5a908"
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