class Depot < Formula
  desc "Build your Docker images in the cloud"
  homepage "https://depot.dev/"
  url "https://ghfast.top/https://github.com/depot/cli/archive/refs/tags/v2.102.15.tar.gz"
  sha256 "2d4e4c561875ed7eccbe5a67f3f969a44119814750ba61a3f711ad572aff0710"
  license "MIT"
  head "https://github.com/depot/cli.git", branch: "main"

  # Upstream sometimes creates a tag with a stable version format but does not
  # create a release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "24657a8fe3afaaca74eb9cd0decd6496524ca8c63264b5fab8715414b55d9870"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "24657a8fe3afaaca74eb9cd0decd6496524ca8c63264b5fab8715414b55d9870"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "24657a8fe3afaaca74eb9cd0decd6496524ca8c63264b5fab8715414b55d9870"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d3d7cc23196d128f1a123fee2a434e0073375a3c1a58bda6f215c3202f1af89e"
    sha256 cellar: :any,                 x86_64_linux:      "924a7ffcba7a282d7c07cd90a3e3380fa66e4508db6c8b4cbe574af424176b47"
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