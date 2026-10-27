class Depot < Formula
  desc "Build your Docker images in the cloud"
  homepage "https://depot.dev/"
  url "https://ghfast.top/https://github.com/depot/cli/archive/refs/tags/v2.103.3.tar.gz"
  sha256 "718dcec55cff8925a26a03dfa6ee1423bdcd4dc95a7c24e0872f8dd72b4edfb3"
  license "MIT"
  head "https://github.com/depot/cli.git", branch: "main"

  # Upstream sometimes creates a tag with a stable version format but does not
  # create a release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "dd3d29bda0a6474df74c48ee1d3ce496c3be69c92973f845d8309bef64b7b076"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "dd3d29bda0a6474df74c48ee1d3ce496c3be69c92973f845d8309bef64b7b076"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "dd3d29bda0a6474df74c48ee1d3ce496c3be69c92973f845d8309bef64b7b076"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "238d9802e20a360fc8722414ec07f9fc31471349528f9154ba87fed427f53f05"
    sha256 cellar: :any,                 x86_64_linux:      "8ec0028f6da635641936c9de2b8ad85139317f2e8026b603b0e5df5fa355a81d"
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