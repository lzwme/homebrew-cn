class Depot < Formula
  desc "Build your Docker images in the cloud"
  homepage "https://depot.dev/"
  url "https://ghfast.top/https://github.com/depot/cli/archive/refs/tags/v2.101.46.tar.gz"
  sha256 "b22a415e02b485c69691346cbe78c97db5c3877c5ff7bb840f97ed7aaa2acfa9"
  license "MIT"
  head "https://github.com/depot/cli.git", branch: "main"

  # Upstream sometimes creates a tag with a stable version format but does not
  # create a release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "07a1d30f241d6017d6b1667086596463834a1ac38427a63b5b2a5470972c3f8d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "07a1d30f241d6017d6b1667086596463834a1ac38427a63b5b2a5470972c3f8d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "07a1d30f241d6017d6b1667086596463834a1ac38427a63b5b2a5470972c3f8d"
    sha256 cellar: :any_skip_relocation, sonoma:        "cba9b4813e6ab8245d47c0b24b056fe85e7f39abd9262b8baa5deb1eb00e8393"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e7956799bd12b3f782447ecc3d0949129bea55dcfcf7572846577a0f98d30b9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "79eaa56fec73aba2d0e6e3b5a4ce373ce6fbeb49c75e736dc6b7e4330e997360"
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