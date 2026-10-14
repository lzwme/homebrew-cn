class Depot < Formula
  desc "Build your Docker images in the cloud"
  homepage "https://depot.dev/"
  url "https://ghfast.top/https://github.com/depot/cli/archive/refs/tags/v2.102.21.tar.gz"
  sha256 "7ee8301c2e05dd10b673ee9136834c9a80324a3a1c0a6ddf2c1a01c45cc38b67"
  license "MIT"
  head "https://github.com/depot/cli.git", branch: "main"

  # Upstream sometimes creates a tag with a stable version format but does not
  # create a release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "868216306a80986f2c6cccb48a2cb8d94f5dafe609992dbe51e1b05e6b87e7ad"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "868216306a80986f2c6cccb48a2cb8d94f5dafe609992dbe51e1b05e6b87e7ad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "868216306a80986f2c6cccb48a2cb8d94f5dafe609992dbe51e1b05e6b87e7ad"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "057654c003b44c150236957c7030dd9a14d0f0807073c895bb51fbe4de1bb4c0"
    sha256 cellar: :any,                 x86_64_linux:      "9f624daaaf62011baa868ec1cc33336db79dd8cc2f2b6c570150d95019f90f62"
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