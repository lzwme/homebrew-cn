class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.1.54",
      revision: "384fc52fc2b662aa9a9d00a2f71ad924681e8b42"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dd19484ddca591a5409a9a171232f4d4f6cd3ddb0c5cbaa2fc8004d7fa48045f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dd19484ddca591a5409a9a171232f4d4f6cd3ddb0c5cbaa2fc8004d7fa48045f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dd19484ddca591a5409a9a171232f4d4f6cd3ddb0c5cbaa2fc8004d7fa48045f"
    sha256 cellar: :any_skip_relocation, ventura:        "24a90b03d20d67deb07d390ed45756fe2f709c3c785afeb1d2775e88c19abce3"
    sha256 cellar: :any_skip_relocation, monterey:       "24a90b03d20d67deb07d390ed45756fe2f709c3c785afeb1d2775e88c19abce3"
    sha256 cellar: :any_skip_relocation, big_sur:        "24a90b03d20d67deb07d390ed45756fe2f709c3c785afeb1d2775e88c19abce3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "463a25c5a80c0e4ff868c17d558e8d08c706aaf6a59e9291b063c431b92c06ac"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -X github.com/superfly/flyctl/internal/buildinfo.environment=production
      -X github.com/superfly/flyctl/internal/buildinfo.buildDate=#{time.iso8601}
      -X github.com/superfly/flyctl/internal/buildinfo.version=#{version}
      -X github.com/superfly/flyctl/internal/buildinfo.commit=#{Utils.git_short_head}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    bin.install_symlink "flyctl" => "fly"

    generate_completions_from_executable(bin/"flyctl", "completion")
  end

  test do
    assert_match "flyctl v#{version}", shell_output("#{bin}/flyctl version")

    flyctl_status = shell_output("#{bin}/flyctl status 2>&1", 1)
    assert_match "Error: No access token available. Please login with 'flyctl auth login'", flyctl_status
  end
end