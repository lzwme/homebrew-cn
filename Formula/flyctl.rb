class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.1.10",
      revision: "f721011f4b00ba47b267e7fa254591ad4a132de1"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4a50202bcdafc5247257a2eeb6eee1e8ceca34cb408e859f68fa2f116805ce2a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4a50202bcdafc5247257a2eeb6eee1e8ceca34cb408e859f68fa2f116805ce2a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4a50202bcdafc5247257a2eeb6eee1e8ceca34cb408e859f68fa2f116805ce2a"
    sha256 cellar: :any_skip_relocation, ventura:        "f37b8653355b78294e30b30d312860a9da569f14315f5b6674534607e224f1df"
    sha256 cellar: :any_skip_relocation, monterey:       "f37b8653355b78294e30b30d312860a9da569f14315f5b6674534607e224f1df"
    sha256 cellar: :any_skip_relocation, big_sur:        "f37b8653355b78294e30b30d312860a9da569f14315f5b6674534607e224f1df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a30e4f425aa628dbe9d0bc773ea35b128fb11d115c28057d2e91bf99bb141e34"
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