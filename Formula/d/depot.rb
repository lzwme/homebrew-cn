class Depot < Formula
  desc "Build your Docker images in the cloud"
  homepage "https://depot.dev/"
  url "https://ghfast.top/https://github.com/depot/cli/archive/refs/tags/v2.101.73.tar.gz"
  sha256 "6057e37bfcf99597de90591f809191634eb1b569b327417c86f2f3403a4a9635"
  license "MIT"
  head "https://github.com/depot/cli.git", branch: "main"

  # Upstream sometimes creates a tag with a stable version format but does not
  # create a release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6542cd3d801d0d92dd94e1d5e9435b8a9c5d1a1837b983bac1a1d9984cd7b77a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6542cd3d801d0d92dd94e1d5e9435b8a9c5d1a1837b983bac1a1d9984cd7b77a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6542cd3d801d0d92dd94e1d5e9435b8a9c5d1a1837b983bac1a1d9984cd7b77a"
    sha256 cellar: :any_skip_relocation, sonoma:        "9f2c0a97afcafae06c142bfb059e364dacc5b5ee1ff4c7ee4239a1e1499e29aa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "244e63609512d4933a57a98e2a1cb23a66e06fa9c030c3ff14f097a337470be4"
    sha256 cellar: :any,                 x86_64_linux:  "390e93c25ecd15fce85c8f8197e12f3421f4ba158a7aae473eb06b1e59733d4c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
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