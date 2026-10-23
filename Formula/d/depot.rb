class Depot < Formula
  desc "Build your Docker images in the cloud"
  homepage "https://depot.dev/"
  url "https://ghfast.top/https://github.com/depot/cli/archive/refs/tags/v2.103.2.tar.gz"
  sha256 "71264da73c2580126cbf1296966b45b2d751d426d9eb669997f3ab944e0d7730"
  license "MIT"
  head "https://github.com/depot/cli.git", branch: "main"

  # Upstream sometimes creates a tag with a stable version format but does not
  # create a release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "de581a7e7dad308bb2497546f2ef5fdcbdd455f25e8c5ccf94daeff843322a0d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "de581a7e7dad308bb2497546f2ef5fdcbdd455f25e8c5ccf94daeff843322a0d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "de581a7e7dad308bb2497546f2ef5fdcbdd455f25e8c5ccf94daeff843322a0d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "02f13039ac3d41acbb1bb0296a3179910606fba976ff558bf77f4bb6fa1f78e1"
    sha256 cellar: :any,                 x86_64_linux:      "2c3ace482c5b6f62f9e12d2e08fd27f05b5fb38aa3e726c11e3e6642dfacbc3c"
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