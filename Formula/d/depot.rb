class Depot < Formula
  desc "Build your Docker images in the cloud"
  homepage "https://depot.dev/"
  url "https://ghfast.top/https://github.com/depot/cli/archive/refs/tags/v2.102.6.tar.gz"
  sha256 "225b34e6f7f26916f68947b33bee44ec21d3d3132a8e6568ddee9d805ed22c4c"
  license "MIT"
  head "https://github.com/depot/cli.git", branch: "main"

  # Upstream sometimes creates a tag with a stable version format but does not
  # create a release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cfaa062d559b117b03e8f0d7e358be0aa4f70a986e61532d607d37331bc0807a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cfaa062d559b117b03e8f0d7e358be0aa4f70a986e61532d607d37331bc0807a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cfaa062d559b117b03e8f0d7e358be0aa4f70a986e61532d607d37331bc0807a"
    sha256 cellar: :any_skip_relocation, sonoma:        "9f0f3fac787ab6f366866fbf6ef97aefb485691a80988827674505602c737cf3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "17e7880b0606e76fe30a955a07c1c9db205895e59760f5b436dfe93e8fca3a4d"
    sha256 cellar: :any,                 x86_64_linux:  "4d5f2a5ea571d541d0dede68f0559f53a40d8eb6860b38cc8bc3bf3777eadb92"
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