class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.1.44",
      revision: "026919cf120570214f74fb3f56c687b92e0d6160"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "080168652fce2060458bfd79acfb49dae70dfb0af072a56521a4fc6d26a90b04"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "080168652fce2060458bfd79acfb49dae70dfb0af072a56521a4fc6d26a90b04"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "080168652fce2060458bfd79acfb49dae70dfb0af072a56521a4fc6d26a90b04"
    sha256 cellar: :any_skip_relocation, ventura:        "f4112a0800c0263c9307b3bc43a1d4fbb1ede3439a816f64d30df1474f09cfc4"
    sha256 cellar: :any_skip_relocation, monterey:       "f4112a0800c0263c9307b3bc43a1d4fbb1ede3439a816f64d30df1474f09cfc4"
    sha256 cellar: :any_skip_relocation, big_sur:        "f4112a0800c0263c9307b3bc43a1d4fbb1ede3439a816f64d30df1474f09cfc4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "71bdd583c51856767e49940fa85508438b9f4161b1c06ff9c0028e14bf1f846c"
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