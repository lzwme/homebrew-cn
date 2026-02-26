class Depot < Formula
  desc "Build your Docker images in the cloud"
  homepage "https://depot.dev/"
  url "https://ghfast.top/https://github.com/depot/cli/archive/refs/tags/v2.101.13.tar.gz"
  sha256 "ec8ba3f1408f14c15b0b556b7fceb2c922d6dfffe5b7e5ba540e922839e6d97e"
  license "MIT"
  head "https://github.com/depot/cli.git", branch: "main"

  # Upstream sometimes creates a tag with a stable version format but does not
  # create a release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "81bbc79eba4e46040497970698ac08c03fc1fc7ad7793adf83860566773db3ff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "81bbc79eba4e46040497970698ac08c03fc1fc7ad7793adf83860566773db3ff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "81bbc79eba4e46040497970698ac08c03fc1fc7ad7793adf83860566773db3ff"
    sha256 cellar: :any_skip_relocation, sonoma:        "950dbd2c4ca7219709b181b8a44df733b53a91f0221f5f9eac796d8861ce4eb4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "df75e38aa37b0afa397e243d05932a5c4336cabd2174746c6abaf2ce85196d8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ece493617bccb3cbdca26f3756509e5e3932a792881c032ef7ede4196905a64c"
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