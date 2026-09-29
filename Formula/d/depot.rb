class Depot < Formula
  desc "Build your Docker images in the cloud"
  homepage "https://depot.dev/"
  url "https://ghfast.top/https://github.com/depot/cli/archive/refs/tags/v2.102.14.tar.gz"
  sha256 "4bd6cf3a50dddef9aeec4c0bd390bfcb6b795cdcb1a9cfda5ceb67688e1e6555"
  license "MIT"
  head "https://github.com/depot/cli.git", branch: "main"

  # Upstream sometimes creates a tag with a stable version format but does not
  # create a release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "67289102525c4d2ef4284475a2b4d598c51ddadb6bbf91bd3080e2221d73ddc1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "67289102525c4d2ef4284475a2b4d598c51ddadb6bbf91bd3080e2221d73ddc1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "67289102525c4d2ef4284475a2b4d598c51ddadb6bbf91bd3080e2221d73ddc1"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "81eec587efe86abc162043f80f3a8c65a0eee9070af6c077fd4f69ec5815ede7"
    sha256 cellar: :any,                 x86_64_linux:      "e07e32da054fddcdc6231c1a00b1cb2af2699389d1bfcfff8d75e57ef26fb75e"
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