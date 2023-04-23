class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.539",
      revision: "0cee79174328505a58aced8fae6d727a1445623f"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "df6a1ae1e80b3d6e91a68c4bf681d609e37158fc8576f5609f22105579ac99fe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "df6a1ae1e80b3d6e91a68c4bf681d609e37158fc8576f5609f22105579ac99fe"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "df6a1ae1e80b3d6e91a68c4bf681d609e37158fc8576f5609f22105579ac99fe"
    sha256 cellar: :any_skip_relocation, ventura:        "4ae0f10132100a83b3a6876cfb49bf804c5de2a6adf431ebc036c71a8aff78d3"
    sha256 cellar: :any_skip_relocation, monterey:       "4ae0f10132100a83b3a6876cfb49bf804c5de2a6adf431ebc036c71a8aff78d3"
    sha256 cellar: :any_skip_relocation, big_sur:        "4ae0f10132100a83b3a6876cfb49bf804c5de2a6adf431ebc036c71a8aff78d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "66462a6d647e132aeae5660898585d755e976e3b2644b989395580b5240480b8"
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