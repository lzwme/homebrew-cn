class Depot < Formula
  desc "Build your Docker images in the cloud"
  homepage "https://depot.dev/"
  url "https://ghfast.top/https://github.com/depot/cli/archive/refs/tags/v2.101.35.tar.gz"
  sha256 "5fca59d82c48fde468d87f4c5f25bc76f02856ac37b57507f91d5434578332f2"
  license "MIT"
  head "https://github.com/depot/cli.git", branch: "main"

  # Upstream sometimes creates a tag with a stable version format but does not
  # create a release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3b4723240691ed4317c011fa1235f5e6fd7a86a0902b2e5a2ddb890784271f18"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3b4723240691ed4317c011fa1235f5e6fd7a86a0902b2e5a2ddb890784271f18"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3b4723240691ed4317c011fa1235f5e6fd7a86a0902b2e5a2ddb890784271f18"
    sha256 cellar: :any_skip_relocation, sonoma:        "6f36144fc4a263582fe767aea6659f508592625a71ca5477290802733bcfea13"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d2fe5f2fd62376e7c27dcee837349cf5187e3d2cdaa9c268a6b3fa5c97651f81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5bbc2b5f74a8fd4ce7b6fc2d1564478660e28207c9180c9e3e0c0cebd21a45b1"
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