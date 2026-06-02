class Depot < Formula
  desc "Build your Docker images in the cloud"
  homepage "https://depot.dev/"
  url "https://ghfast.top/https://github.com/depot/cli/archive/refs/tags/v2.101.64.tar.gz"
  sha256 "3c80d8a1d4ec9c539bdede3adcff7440cebeb56dd7285f2fe32572f078761290"
  license "MIT"
  head "https://github.com/depot/cli.git", branch: "main"

  # Upstream sometimes creates a tag with a stable version format but does not
  # create a release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "42dc78f89958dce04711178bf2af1c1c57147d691bd8aeb7a9eea6287d531416"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "42dc78f89958dce04711178bf2af1c1c57147d691bd8aeb7a9eea6287d531416"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "42dc78f89958dce04711178bf2af1c1c57147d691bd8aeb7a9eea6287d531416"
    sha256 cellar: :any_skip_relocation, sonoma:        "a2a23a99e995122e3b2ea6d551c0ae656dc34df7c9f67a8ee31d0b6c945dc21a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bfe47dcb70a9bd1792ad75f19009ff42bc4a15bf9781874443020bf63f867396"
    sha256 cellar: :any,                 x86_64_linux:  "5d6b27f913a09d502022cc0e179269b29044888174561979ebe3f95f769e5bec"
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