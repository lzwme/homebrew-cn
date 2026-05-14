class Depot < Formula
  desc "Build your Docker images in the cloud"
  homepage "https://depot.dev/"
  url "https://ghfast.top/https://github.com/depot/cli/archive/refs/tags/v2.101.61.tar.gz"
  sha256 "243291bba85305ad27b69c0be5978f9fbae042bcddcee3dc8c3ba012007fca37"
  license "MIT"
  head "https://github.com/depot/cli.git", branch: "main"

  # Upstream sometimes creates a tag with a stable version format but does not
  # create a release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2369ef83c5b2da07cd72a2ca6b31280220075f95a6e3ac0ab57467254fcbd471"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2369ef83c5b2da07cd72a2ca6b31280220075f95a6e3ac0ab57467254fcbd471"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2369ef83c5b2da07cd72a2ca6b31280220075f95a6e3ac0ab57467254fcbd471"
    sha256 cellar: :any_skip_relocation, sonoma:        "784938cba3a49279f97992755c23d7de6b8ad1f3a4fc9f017053ea657ebacfa6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b7973125f94890720539f5bf9ede9053c1be23bc5badc2918c57a0471ee16565"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "437f416937ca334dc70ba99964f03281d59793b09dc5c46ea562a9d849304ed3"
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