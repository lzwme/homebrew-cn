class Depot < Formula
  desc "Build your Docker images in the cloud"
  homepage "https://depot.dev/"
  url "https://ghfast.top/https://github.com/depot/cli/archive/refs/tags/v2.102.8.tar.gz"
  sha256 "e93bccef5b745e7d07d23300bc5a29d6ad5b189c4feee88af751e3b23611eab7"
  license "MIT"
  head "https://github.com/depot/cli.git", branch: "main"

  # Upstream sometimes creates a tag with a stable version format but does not
  # create a release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "500d0a0223cb705e6f0e3274f1ef59264ee14fbb6bf306620103029f3bc38960"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "500d0a0223cb705e6f0e3274f1ef59264ee14fbb6bf306620103029f3bc38960"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "500d0a0223cb705e6f0e3274f1ef59264ee14fbb6bf306620103029f3bc38960"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0b9f6e5a14a2683cddcfafed50b2209c44b32eee56e9a803d101efb2f8effed9"
    sha256 cellar: :any,                 x86_64_linux:      "88e185b0970f52ccb62b8b4156030ebe27e6314486303e09a7cf850cf1870d65"
  end

  depends_on "go" => :build

  # Fix linking on Linux arm64 with Go 1.27, which rejects cpuid 2.0.4's linkname to `runtime.sched_getaffinity`.
  patch do
    url "https://github.com/depot/cli/commit/627f8a6dfad7e7f2f33c774d3aa22af9884f0ebb.patch?full_index=1"
    sha256 "bffa3eaea34bebeeb3c27fb9ed326137b8824a1ded170eeeb2cdd91c30dd48ac"
    type :unofficial
    resolves "https://github.com/depot/cli/pull/570"
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