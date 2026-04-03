class Depot < Formula
  desc "Build your Docker images in the cloud"
  homepage "https://depot.dev/"
  url "https://ghfast.top/https://github.com/depot/cli/archive/refs/tags/v2.101.37.tar.gz"
  sha256 "e8fee50cc5ce97733035ca59fb0184cb27cc4b4154ca9b1201af45634471a14d"
  license "MIT"
  head "https://github.com/depot/cli.git", branch: "main"

  # Upstream sometimes creates a tag with a stable version format but does not
  # create a release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "74c18709ef8676602566dc29d1432e423dac28ec266e5eaa63fc7aeed6188865"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "74c18709ef8676602566dc29d1432e423dac28ec266e5eaa63fc7aeed6188865"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "74c18709ef8676602566dc29d1432e423dac28ec266e5eaa63fc7aeed6188865"
    sha256 cellar: :any_skip_relocation, sonoma:        "9e79fa47b222dbc0ad779fba3697516e80376a13b9e85e813bcf0775278854ff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "200612e4718ca39a7dcf889626e04b2365f3d2eda0f528185aede6b2db4f1a8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4fd160c49619624b1e8f7099bfedea3c0c64264d7f5f59e89bca430e073383dd"
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