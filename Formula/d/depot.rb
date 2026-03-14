class Depot < Formula
  desc "Build your Docker images in the cloud"
  homepage "https://depot.dev/"
  url "https://ghfast.top/https://github.com/depot/cli/archive/refs/tags/v2.101.19.tar.gz"
  sha256 "66e84c1e52493e84dc71b2161b99c626126cb94b90b39a5756940be544c703a6"
  license "MIT"
  head "https://github.com/depot/cli.git", branch: "main"

  # Upstream sometimes creates a tag with a stable version format but does not
  # create a release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "731c667b4c965d405f7ca28d2e353fc13ef881c3096b7b4a51d1fdf0b3b8a528"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "731c667b4c965d405f7ca28d2e353fc13ef881c3096b7b4a51d1fdf0b3b8a528"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "731c667b4c965d405f7ca28d2e353fc13ef881c3096b7b4a51d1fdf0b3b8a528"
    sha256 cellar: :any_skip_relocation, sonoma:        "436cb04afffb0d467872e13130ae09c66a4ec0957932765a95afd7d96c7ce646"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "166d020e4e319bbea86aa6f09eb4a2bc8916f36f62e8f1d02e42fea6cabf8e1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "68c5ba6daaa603924827039614f3518b969aa2b58320b464b6c698526a882bb1"
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