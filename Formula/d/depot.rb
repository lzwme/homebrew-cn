class Depot < Formula
  desc "Build your Docker images in the cloud"
  homepage "https://depot.dev/"
  url "https://ghfast.top/https://github.com/depot/cli/archive/refs/tags/v2.103.5.tar.gz"
  sha256 "d6fa19b1c9e7b00bdb4fe0a08a701e8bec365dd162e8e36534607d3ae8987e4d"
  license "MIT"
  head "https://github.com/depot/cli.git", branch: "main"

  # Upstream sometimes creates a tag with a stable version format but does not
  # create a release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6620a0497bc62e0079af2b6699533a5597c243dc137c027957a647b3b0dac842"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6620a0497bc62e0079af2b6699533a5597c243dc137c027957a647b3b0dac842"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6620a0497bc62e0079af2b6699533a5597c243dc137c027957a647b3b0dac842"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "cb96ef837500ed7625ddad3b574023b77975d66c51856502757eb86a31b40e98"
    sha256 cellar: :any,                 x86_64_linux:      "b1c1b607bf8ed48c91645f16622e8dc2171af0b92d7bae5ade280ec4a3eeb1c6"
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