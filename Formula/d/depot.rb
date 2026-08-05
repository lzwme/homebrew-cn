class Depot < Formula
  desc "Build your Docker images in the cloud"
  homepage "https://depot.dev/"
  url "https://ghfast.top/https://github.com/depot/cli/archive/refs/tags/v2.101.78.tar.gz"
  sha256 "f54c0e714e30e6149e19f04f1fa8ec8f29add9da6d80c521a20a47009a5e8cd5"
  license "MIT"
  head "https://github.com/depot/cli.git", branch: "main"

  # Upstream sometimes creates a tag with a stable version format but does not
  # create a release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9d4bfa891e1cd1222a61f72538cdc64104cdb9e8cadce8f5e49bc060f2c67d4f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9d4bfa891e1cd1222a61f72538cdc64104cdb9e8cadce8f5e49bc060f2c67d4f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9d4bfa891e1cd1222a61f72538cdc64104cdb9e8cadce8f5e49bc060f2c67d4f"
    sha256 cellar: :any_skip_relocation, sonoma:        "0739c31216244d56bc37f4ebc516277ff33a0aa8abccab8d7d11a88dbad82fd4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f8572364c43b6c56f6f8a01e42e6394fd900c6b984eac5907d590f04d53ff326"
    sha256 cellar: :any,                 x86_64_linux:  "96b29997829dfcebffbe78fafd16f5aeeb07182c38650013f17103a4ef0e5a55"
  end

  depends_on "go" => :build

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