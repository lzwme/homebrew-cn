class Depot < Formula
  desc "Build your Docker images in the cloud"
  homepage "https://depot.dev/"
  url "https://ghfast.top/https://github.com/depot/cli/archive/refs/tags/v2.101.57.tar.gz"
  sha256 "ab1931101ffbcda059be1fbe4d1870473e353e7a821994e7d03e22271a52f529"
  license "MIT"
  head "https://github.com/depot/cli.git", branch: "main"

  # Upstream sometimes creates a tag with a stable version format but does not
  # create a release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7b98d7cf654508ed79da588afd2278285bfb54db180c160526f7bec2e61f621d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7b98d7cf654508ed79da588afd2278285bfb54db180c160526f7bec2e61f621d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7b98d7cf654508ed79da588afd2278285bfb54db180c160526f7bec2e61f621d"
    sha256 cellar: :any_skip_relocation, sonoma:        "073afdd03a176605669a74e156eead7018082061e4852b87a7897335ca7f579a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1f5c602d0d1918ebf4266b0e2a5f94d02f8cf3e19cd9945f8122382b2f9660bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3010539a3b47f62b9283d3790b048629b5d52a332e0fbecfd67e840a3a4aaead"
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