class Depot < Formula
  desc "Build your Docker images in the cloud"
  homepage "https://depot.dev/"
  url "https://ghfast.top/https://github.com/depot/cli/archive/refs/tags/v2.101.15.tar.gz"
  sha256 "08992c0a11f241566d548cbc89f1b10f83fa8ed0eb16627f9d2585355cd2e755"
  license "MIT"
  head "https://github.com/depot/cli.git", branch: "main"

  # Upstream sometimes creates a tag with a stable version format but does not
  # create a release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a3c81b8f4606ce0e8e5051919bb6073e70204d801943e38d88da4eccda5f7fbf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a3c81b8f4606ce0e8e5051919bb6073e70204d801943e38d88da4eccda5f7fbf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a3c81b8f4606ce0e8e5051919bb6073e70204d801943e38d88da4eccda5f7fbf"
    sha256 cellar: :any_skip_relocation, sonoma:        "1a7db12eac6b0f2f06124dc790717ef408ed9bf4e62a97af6b771efb1ff906db"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "627ece65fa39c487e7ae0893daa320291f28205cf59dd247cf13805872e3cc21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ce0b293b004cee045a1ce14c0cb93abad293f6f1c050fbc35396024a7bf2b2e3"
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