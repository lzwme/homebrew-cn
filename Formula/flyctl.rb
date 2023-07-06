class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.1.50",
      revision: "6c7afb029df1f56b316f87c300a69d88dac6d898"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d603853c29dc695f0ce6b5a96bc5c36157bacaae3d406efb52654bc558062375"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d603853c29dc695f0ce6b5a96bc5c36157bacaae3d406efb52654bc558062375"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d603853c29dc695f0ce6b5a96bc5c36157bacaae3d406efb52654bc558062375"
    sha256 cellar: :any_skip_relocation, ventura:        "6ad8b6f773c1bf5071178982b713aa3106ee7477b4b96c88d766d5c08ec4d5a3"
    sha256 cellar: :any_skip_relocation, monterey:       "6ad8b6f773c1bf5071178982b713aa3106ee7477b4b96c88d766d5c08ec4d5a3"
    sha256 cellar: :any_skip_relocation, big_sur:        "6ad8b6f773c1bf5071178982b713aa3106ee7477b4b96c88d766d5c08ec4d5a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ad97de19b9781f9b598891008a0b402fc8999649f22897775c628289383c49e5"
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