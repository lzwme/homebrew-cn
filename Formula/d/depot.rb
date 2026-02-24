class Depot < Formula
  desc "Build your Docker images in the cloud"
  homepage "https://depot.dev/"
  url "https://ghfast.top/https://github.com/depot/cli/archive/refs/tags/v2.101.10.tar.gz"
  sha256 "079c44cc67c18458e628a75ec1662f7d0b2a08f885ecf9117f06925993840aa8"
  license "MIT"
  head "https://github.com/depot/cli.git", branch: "main"

  # Upstream sometimes creates a tag with a stable version format but does not
  # create a release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8f71fac4440820912303af08ed60eb0f9cbd5a7da9bc7b21f1b364dba71f87ce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8f71fac4440820912303af08ed60eb0f9cbd5a7da9bc7b21f1b364dba71f87ce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8f71fac4440820912303af08ed60eb0f9cbd5a7da9bc7b21f1b364dba71f87ce"
    sha256 cellar: :any_skip_relocation, sonoma:        "f79ececfbec976b73274e00701a35fd40300aa3f8f66994e40ddbea876a8879f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "af5571d672a354d176dcfa74eb7f931be47c4fdcf8c23f5f04ee78461527d8c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "14bd1e8ea320e26369ecc7ce9f73401adfae925cd83a90fe55eb463c0f4f10a6"
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