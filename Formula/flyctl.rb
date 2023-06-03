class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.1.26",
      revision: "4f0cc0dda12801e566e460d1c47c60815052fd89"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e38481ad761966eba56e8c7df5ff239ac18f4386c9fe5286c5f17c041cefd201"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e38481ad761966eba56e8c7df5ff239ac18f4386c9fe5286c5f17c041cefd201"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e38481ad761966eba56e8c7df5ff239ac18f4386c9fe5286c5f17c041cefd201"
    sha256 cellar: :any_skip_relocation, ventura:        "cec2713c1912b4cb983ae50dddcfed0bab53d3c528d4e3bc47d2c3e980d378b2"
    sha256 cellar: :any_skip_relocation, monterey:       "cec2713c1912b4cb983ae50dddcfed0bab53d3c528d4e3bc47d2c3e980d378b2"
    sha256 cellar: :any_skip_relocation, big_sur:        "cec2713c1912b4cb983ae50dddcfed0bab53d3c528d4e3bc47d2c3e980d378b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "444714d926614e7d470dd097cf5006810f242971e971d3d1f3eeacffda68afc9"
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