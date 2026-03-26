class Depot < Formula
  desc "Build your Docker images in the cloud"
  homepage "https://depot.dev/"
  url "https://ghfast.top/https://github.com/depot/cli/archive/refs/tags/v2.101.31.tar.gz"
  sha256 "e777c150bb5664475ae3b06be3dafc590c859eadff5f6d80fbdfd4afad8496ce"
  license "MIT"
  head "https://github.com/depot/cli.git", branch: "main"

  # Upstream sometimes creates a tag with a stable version format but does not
  # create a release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7b40ef1d1b5a299bc3ddad29775f43524abbb774978a6e14455957b8511aae45"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7b40ef1d1b5a299bc3ddad29775f43524abbb774978a6e14455957b8511aae45"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7b40ef1d1b5a299bc3ddad29775f43524abbb774978a6e14455957b8511aae45"
    sha256 cellar: :any_skip_relocation, sonoma:        "50724c4c434904d7d9fa3fb2244c9cd4d892318b17a9b7e1766bee360a426ae0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4150e9ed9238c345f6f7e3098f08700e64007cfe12d692a98933cf5f9116f06e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff11f3727931efba0c8e6c706527be23734e7a454f1f0d98f75a7b4afc1a5b18"
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