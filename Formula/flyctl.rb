class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.1.28",
      revision: "6182cf38d60a81f8ba12e7542481e4fa1e03ffdb"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "93609ce5bcbad37e6f9b1c5763e6149b6d843d6c6b111f61faaa1b589d54702f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "93609ce5bcbad37e6f9b1c5763e6149b6d843d6c6b111f61faaa1b589d54702f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "93609ce5bcbad37e6f9b1c5763e6149b6d843d6c6b111f61faaa1b589d54702f"
    sha256 cellar: :any_skip_relocation, ventura:        "6f8eed94cfe5e3bc20e64f5e1e9afaebe737fa9db776987c85f099b634830dfa"
    sha256 cellar: :any_skip_relocation, monterey:       "6f8eed94cfe5e3bc20e64f5e1e9afaebe737fa9db776987c85f099b634830dfa"
    sha256 cellar: :any_skip_relocation, big_sur:        "6f8eed94cfe5e3bc20e64f5e1e9afaebe737fa9db776987c85f099b634830dfa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b2c1e4bb459c06b720ad168db627068876cee6efae595b0f996ef958dae7141f"
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