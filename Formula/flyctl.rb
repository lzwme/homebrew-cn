class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.1.71",
      revision: "8ce0e8d984ec3ea695523b80eca6035974367674"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "24a514815bace3354c6fbdf794a321aeff5e1a6f346b3e78a6baf3749c9f4cfe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "24a514815bace3354c6fbdf794a321aeff5e1a6f346b3e78a6baf3749c9f4cfe"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "24a514815bace3354c6fbdf794a321aeff5e1a6f346b3e78a6baf3749c9f4cfe"
    sha256 cellar: :any_skip_relocation, ventura:        "8754c3ac04da9e5db229e5a6e763ebff11357b4a93e6d0ef9a3266443791f056"
    sha256 cellar: :any_skip_relocation, monterey:       "8754c3ac04da9e5db229e5a6e763ebff11357b4a93e6d0ef9a3266443791f056"
    sha256 cellar: :any_skip_relocation, big_sur:        "8754c3ac04da9e5db229e5a6e763ebff11357b4a93e6d0ef9a3266443791f056"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "77977290fac7967ef8ce80e1044ffc959e63c93c79dc01a9b2cabd9713f7a140"
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