class Depot < Formula
  desc "Build your Docker images in the cloud"
  homepage "https://depot.dev/"
  url "https://ghfast.top/https://github.com/depot/cli/archive/refs/tags/v2.101.9.tar.gz"
  sha256 "29f533d119092ec497d8398f5e395ed88bfadc8146bdc3dd4d90c1987bcea2b6"
  license "MIT"
  head "https://github.com/depot/cli.git", branch: "main"

  # Upstream sometimes creates a tag with a stable version format but does not
  # create a release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "49d81e245eb83aac4d3e8f0a59aad2611c4af131a02a55198df264b668b5ea9e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "49d81e245eb83aac4d3e8f0a59aad2611c4af131a02a55198df264b668b5ea9e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "49d81e245eb83aac4d3e8f0a59aad2611c4af131a02a55198df264b668b5ea9e"
    sha256 cellar: :any_skip_relocation, sonoma:        "7dbf8d50058a95b93ce2dd7a4ac49a453fa30f492e39fb6fd7043589c35fcde1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f28113b4fb335d13c3c733269ceb1e2a52ce78dc3d9f515ad4a7b74f327d8ae2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ee7f0c22bec6c53d3a7dc9fa9bc49442f8cf88a312bb411399a17c150071af17"
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