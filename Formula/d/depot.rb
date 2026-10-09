class Depot < Formula
  desc "Build your Docker images in the cloud"
  homepage "https://depot.dev/"
  url "https://ghfast.top/https://github.com/depot/cli/archive/refs/tags/v2.102.18.tar.gz"
  sha256 "52cca94ed0126324faa2f2de0fe1bafd2f080ca8a65e8449ba23bfe7cf470af6"
  license "MIT"
  head "https://github.com/depot/cli.git", branch: "main"

  # Upstream sometimes creates a tag with a stable version format but does not
  # create a release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a488d0e24d468b0707a869f82e80892e88b015443296d3e965b0112e9ca498a9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a488d0e24d468b0707a869f82e80892e88b015443296d3e965b0112e9ca498a9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a488d0e24d468b0707a869f82e80892e88b015443296d3e965b0112e9ca498a9"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "6f8cf17aa1729522e89076a8f2ec42a77a7a50dd5c7c9c9fbc2296c9b7202d19"
    sha256 cellar: :any,                 x86_64_linux:      "63274e4ed74605ce810a6f5e9100775538e5be0de74bb89f738548352957284e"
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