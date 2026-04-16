class Depot < Formula
  desc "Build your Docker images in the cloud"
  homepage "https://depot.dev/"
  url "https://ghfast.top/https://github.com/depot/cli/archive/refs/tags/v2.101.43.tar.gz"
  sha256 "93fd7ec50c9cd83d2b46a7b84d63bb255e5fe15250c7238c3606f57f4556a0e7"
  license "MIT"
  head "https://github.com/depot/cli.git", branch: "main"

  # Upstream sometimes creates a tag with a stable version format but does not
  # create a release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ac46ca869c6476e9fcac4f620bd1694cc8d2786a2b731a06399bdaa4b94bc6b0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ac46ca869c6476e9fcac4f620bd1694cc8d2786a2b731a06399bdaa4b94bc6b0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ac46ca869c6476e9fcac4f620bd1694cc8d2786a2b731a06399bdaa4b94bc6b0"
    sha256 cellar: :any_skip_relocation, sonoma:        "8dfcc22bda8c5c3749155e8eb8362d0f2fa3971d8921106161c2764dfea970ce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1b7ee7f93c5bdb4e7ba23a6e5647592ace53cb92c6232ee7a31fcb208b48164e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1462a2b22599ce5717c14485b15592a022c5a0b13deb28e5f4a1943a19af374a"
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
    assert_match "Error: unknown project ID", output
  end
end