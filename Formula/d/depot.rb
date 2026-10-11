class Depot < Formula
  desc "Build your Docker images in the cloud"
  homepage "https://depot.dev/"
  url "https://ghfast.top/https://github.com/depot/cli/archive/refs/tags/v2.102.19.tar.gz"
  sha256 "95b8904784d4891c4a4a50bf76b5784999cddbaa27abd066018083e94f1c54b8"
  license "MIT"
  head "https://github.com/depot/cli.git", branch: "main"

  # Upstream sometimes creates a tag with a stable version format but does not
  # create a release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9e7dfddd21336829d1ad744cba5ab276df087c4e256aff69e73c789d4e4faf0d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9e7dfddd21336829d1ad744cba5ab276df087c4e256aff69e73c789d4e4faf0d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9e7dfddd21336829d1ad744cba5ab276df087c4e256aff69e73c789d4e4faf0d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0b9124e300413a33315929d0c53feb67ef0cf4a99e4c7af239bc6e9d888e23d5"
    sha256 cellar: :any,                 x86_64_linux:      "d7d5db781f393abd7c07d53b4af250cf8b1bc8f77bd422a74ff768fcf2b144a2"
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