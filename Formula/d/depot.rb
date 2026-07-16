class Depot < Formula
  desc "Build your Docker images in the cloud"
  homepage "https://depot.dev/"
  url "https://ghfast.top/https://github.com/depot/cli/archive/refs/tags/v2.101.74.tar.gz"
  sha256 "7579949fb57080309becd6edf53207fde5e93ab73320a63fccc72b07e2c41427"
  license "MIT"
  head "https://github.com/depot/cli.git", branch: "main"

  # Upstream sometimes creates a tag with a stable version format but does not
  # create a release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "217717031f7ae39d2a3ae611649966c26b2940775d3fe23f159b0dd69447d1d7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "217717031f7ae39d2a3ae611649966c26b2940775d3fe23f159b0dd69447d1d7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "217717031f7ae39d2a3ae611649966c26b2940775d3fe23f159b0dd69447d1d7"
    sha256 cellar: :any_skip_relocation, sonoma:        "ce2feb5046cf4f3fcfa69f39c1f6d86c7127ff7375984502730194eca551905b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "49b88b1f2cacb07b85af50fce5908ffd233ebe66a1c72bce3c5f31598ae31f2f"
    sha256 cellar: :any,                 x86_64_linux:  "60b4b12c096dd91d2c3746ff144e46cdd97ddb79a5acf1229da15e93e8f5c72b"
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