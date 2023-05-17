class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.1.6",
      revision: "da96e6137f55f8fdcf26aa3d3b547c89c2958a2c"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "362b9ed8ac32561e164bf82f57dfd132c2e4d2b844cfa2a343bdbe74230a1805"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "362b9ed8ac32561e164bf82f57dfd132c2e4d2b844cfa2a343bdbe74230a1805"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "362b9ed8ac32561e164bf82f57dfd132c2e4d2b844cfa2a343bdbe74230a1805"
    sha256 cellar: :any_skip_relocation, ventura:        "dae09ed64612f8603f12cab9d78babb8399dc18829856ac9baa467c0123d55c8"
    sha256 cellar: :any_skip_relocation, monterey:       "dae09ed64612f8603f12cab9d78babb8399dc18829856ac9baa467c0123d55c8"
    sha256 cellar: :any_skip_relocation, big_sur:        "dae09ed64612f8603f12cab9d78babb8399dc18829856ac9baa467c0123d55c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5e65917a1f27d89eff1e2945c2e3ac75b109a16128e1bd84973fc088794a0a0c"
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