class Depot < Formula
  desc "Build your Docker images in the cloud"
  homepage "https://depot.dev/"
  url "https://ghfast.top/https://github.com/depot/cli/archive/refs/tags/v2.101.11.tar.gz"
  sha256 "45d57118cc7fe514f5b025c7753ce003ba763db6b4027253fa7096092fcecc2e"
  license "MIT"
  head "https://github.com/depot/cli.git", branch: "main"

  # Upstream sometimes creates a tag with a stable version format but does not
  # create a release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "507137ca2361e3565813e5a7f003e73c1746b3a7276c741c68e57d33fb7659fb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "507137ca2361e3565813e5a7f003e73c1746b3a7276c741c68e57d33fb7659fb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "507137ca2361e3565813e5a7f003e73c1746b3a7276c741c68e57d33fb7659fb"
    sha256 cellar: :any_skip_relocation, sonoma:        "7b5113f5f85dac1f947e63d6c769689d421981eb7f6c2bdc9ee9418980eee691"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "757a35165d422ce73cd116c6bc242653fbc79fdb320915a9a7384d409cabf04f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3cd357922312ffaf6fe097fbae7a4d27c7248d3728963bafd86001e7cf0f772e"
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