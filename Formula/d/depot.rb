class Depot < Formula
  desc "Build your Docker images in the cloud"
  homepage "https://depot.dev/"
  url "https://ghfast.top/https://github.com/depot/cli/archive/refs/tags/v2.101.18.tar.gz"
  sha256 "de7a8239c60f7af99f2e28f24e0a887d2636be09291de60a60b14f9c16a0c67e"
  license "MIT"
  head "https://github.com/depot/cli.git", branch: "main"

  # Upstream sometimes creates a tag with a stable version format but does not
  # create a release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "948279b3a8c31be5228dd65814127579ecebafc7c6db8baa0f16971ee6777080"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "948279b3a8c31be5228dd65814127579ecebafc7c6db8baa0f16971ee6777080"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "948279b3a8c31be5228dd65814127579ecebafc7c6db8baa0f16971ee6777080"
    sha256 cellar: :any_skip_relocation, sonoma:        "4ee494159e262b0c83ff5131c43753ed4b37e02b079e012c876d115ad6b4b559"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c92427276f172a1d673c8dafff010ce49cc01442aa44d00d5352d7d10754dc51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0aba5b4b0d5cd7592d3b1124c8bf7ad01b8ef7c9a2a7ae40bbf42ae73fb95a1f"
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