class Depot < Formula
  desc "Build your Docker images in the cloud"
  homepage "https://depot.dev/"
  url "https://ghfast.top/https://github.com/depot/cli/archive/refs/tags/v2.101.72.tar.gz"
  sha256 "db5109add729c4ae076592db40558ede0a4e7787aa672284af979142a25b91bd"
  license "MIT"
  head "https://github.com/depot/cli.git", branch: "main"

  # Upstream sometimes creates a tag with a stable version format but does not
  # create a release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "db142e426d66cc29477cf604e8e8e576e5bc73ad925331b2202b8286bbd56a9d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "db142e426d66cc29477cf604e8e8e576e5bc73ad925331b2202b8286bbd56a9d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "db142e426d66cc29477cf604e8e8e576e5bc73ad925331b2202b8286bbd56a9d"
    sha256 cellar: :any_skip_relocation, sonoma:        "f6fdc2631acc02bf2246b7069852cc8130e44f3587f5274d709012391f0357c7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bf2b272933e239c4ae82847eb8020d64c260a19dfea5c29975ee629ece0a558f"
    sha256 cellar: :any,                 x86_64_linux:  "12033b8605a9627b4ac6fe99d183099a14039b6be6f8dbe0990a153d8916cdd3"
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