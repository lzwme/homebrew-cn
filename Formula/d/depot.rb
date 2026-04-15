class Depot < Formula
  desc "Build your Docker images in the cloud"
  homepage "https://depot.dev/"
  url "https://ghfast.top/https://github.com/depot/cli/archive/refs/tags/v2.101.42.tar.gz"
  sha256 "239114f5d1f231515c100577b17b04278f978d586ea948fad66f4629a8254d38"
  license "MIT"
  head "https://github.com/depot/cli.git", branch: "main"

  # Upstream sometimes creates a tag with a stable version format but does not
  # create a release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d454eaba2e4f99b660c37a2414025d09bc478618534148fc7b44d1612fd6479e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d454eaba2e4f99b660c37a2414025d09bc478618534148fc7b44d1612fd6479e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d454eaba2e4f99b660c37a2414025d09bc478618534148fc7b44d1612fd6479e"
    sha256 cellar: :any_skip_relocation, sonoma:        "3de62c90b07c53ef74884dd90e58e0729bcd229a26731521a88396e00078248a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ec04daa53f209e189077079a8f79530740704108718f55f2a34df0009df946c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c3411882f66dfd415f8625057f8597fdf8a687ce5bd3400eb362ab21209d668f"
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