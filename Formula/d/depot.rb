class Depot < Formula
  desc "Build your Docker images in the cloud"
  homepage "https://depot.dev/"
  url "https://ghfast.top/https://github.com/depot/cli/archive/refs/tags/v2.103.4.tar.gz"
  sha256 "e309296a8a79f963c9169cd60c7205dfcb573c58225faad9eae2eb80a3f6eb93"
  license "MIT"
  head "https://github.com/depot/cli.git", branch: "main"

  # Upstream sometimes creates a tag with a stable version format but does not
  # create a release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c0833f2f5a6f31838a6b796374e89efcf2bc752b57fa442aebd62275393ec1b7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c0833f2f5a6f31838a6b796374e89efcf2bc752b57fa442aebd62275393ec1b7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c0833f2f5a6f31838a6b796374e89efcf2bc752b57fa442aebd62275393ec1b7"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "28104a1d23fcf79e11f14bdddd019257b48520acd72668486a8ca718df5417d5"
    sha256 cellar: :any,                 x86_64_linux:      "7a2568865addab609b3cf9f3eb5ba29050b2948d69d0211d9013d0219b8d3429"
  end

  depends_on "go" => :build

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