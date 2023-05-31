class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.1.23",
      revision: "4aa1bbf64fc3d6696450dec51ccd0bfd5782454c"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "abece688c0f90fb07fa6f83a2ee27aa244d65967c366615496b660d383b98545"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "abece688c0f90fb07fa6f83a2ee27aa244d65967c366615496b660d383b98545"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "abece688c0f90fb07fa6f83a2ee27aa244d65967c366615496b660d383b98545"
    sha256 cellar: :any_skip_relocation, ventura:        "7a15808b5cbfdb7b6379baf425f48f422a31c4811bdb9ae1216421ea44e01210"
    sha256 cellar: :any_skip_relocation, monterey:       "7a15808b5cbfdb7b6379baf425f48f422a31c4811bdb9ae1216421ea44e01210"
    sha256 cellar: :any_skip_relocation, big_sur:        "7a15808b5cbfdb7b6379baf425f48f422a31c4811bdb9ae1216421ea44e01210"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cc48f3b92f4cde3063c71d33335be78aa12f247579a92ae2653b02f2c46b9059"
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