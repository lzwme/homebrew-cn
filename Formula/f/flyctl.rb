class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.1.82",
      revision: "0f378ffb02c01802b9b2a86790fb64aa89917496"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d637a5f2b1f1165c1e98097bffec3dbae200e4d92a3a6e91d8afee2774167a67"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d637a5f2b1f1165c1e98097bffec3dbae200e4d92a3a6e91d8afee2774167a67"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d637a5f2b1f1165c1e98097bffec3dbae200e4d92a3a6e91d8afee2774167a67"
    sha256 cellar: :any_skip_relocation, ventura:        "7ccbe8135a5b1bfa07ca2f053e39dbec1c183afa9f99c367e928134a9888a52a"
    sha256 cellar: :any_skip_relocation, monterey:       "7ccbe8135a5b1bfa07ca2f053e39dbec1c183afa9f99c367e928134a9888a52a"
    sha256 cellar: :any_skip_relocation, big_sur:        "7ccbe8135a5b1bfa07ca2f053e39dbec1c183afa9f99c367e928134a9888a52a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6633aef0bb280431f33f01ecd4bd5ad34ca50c34ad9f3c507e81ae8c47ba3f91"
  end

  # go 1.21.0 support bug report, https://github.com/superfly/flyctl/issues/2688
  depends_on "go@1.20" => :build

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