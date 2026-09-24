class Depot < Formula
  desc "Build your Docker images in the cloud"
  homepage "https://depot.dev/"
  url "https://ghfast.top/https://github.com/depot/cli/archive/refs/tags/v2.102.13.tar.gz"
  sha256 "bd1de42ccdd59047f34e39e3f88e2814859ddef1e95e3bb6766aed83ac6dd325"
  license "MIT"
  head "https://github.com/depot/cli.git", branch: "main"

  # Upstream sometimes creates a tag with a stable version format but does not
  # create a release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2ad6abc6ea19a626fb9d8f20386c7c41f247f8fdbc16ea4cba75fab9d4ccab5d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2ad6abc6ea19a626fb9d8f20386c7c41f247f8fdbc16ea4cba75fab9d4ccab5d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2ad6abc6ea19a626fb9d8f20386c7c41f247f8fdbc16ea4cba75fab9d4ccab5d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "2bc65d6e2ae6d6922294a921193f3f9b2befafa14b459a50831be4628e7f4d31"
    sha256 cellar: :any,                 x86_64_linux:      "4353f5992b5d529c2f6f70d4f4adac80199188b0fae10d7b455f0650af751743"
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