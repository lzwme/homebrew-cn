class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.1.21",
      revision: "727187f143dd6636ba2e6ecdd4675260fc511b82"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5d054eb5bcb5716af2bc4f83faeb9a8a84b809dde5d9d33e9d9402155412b92b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5d054eb5bcb5716af2bc4f83faeb9a8a84b809dde5d9d33e9d9402155412b92b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5d054eb5bcb5716af2bc4f83faeb9a8a84b809dde5d9d33e9d9402155412b92b"
    sha256 cellar: :any_skip_relocation, ventura:        "bcf4c596d592f3d1421950ee766cee8fe75d62a3961c7aefbf1044eaf312ad1a"
    sha256 cellar: :any_skip_relocation, monterey:       "bcf4c596d592f3d1421950ee766cee8fe75d62a3961c7aefbf1044eaf312ad1a"
    sha256 cellar: :any_skip_relocation, big_sur:        "bcf4c596d592f3d1421950ee766cee8fe75d62a3961c7aefbf1044eaf312ad1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1cdb1dd95497f5953d06ddc59241d04189edfcb93cfcf0bee91d6f76283b8a33"
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