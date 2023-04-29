class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.547",
      revision: "9f1e16ae18d98da3599b98bb494ddde7a8f93a92"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e731e014c946f5c0cf6b9b8603bfef57946b7c42d9ad56bf7a3af97bedb6fbf0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e731e014c946f5c0cf6b9b8603bfef57946b7c42d9ad56bf7a3af97bedb6fbf0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e731e014c946f5c0cf6b9b8603bfef57946b7c42d9ad56bf7a3af97bedb6fbf0"
    sha256 cellar: :any_skip_relocation, ventura:        "76b8fe33b8afbbe62a1374165dd7c1d9cceeca923955426cc08eae979d31b0e8"
    sha256 cellar: :any_skip_relocation, monterey:       "76b8fe33b8afbbe62a1374165dd7c1d9cceeca923955426cc08eae979d31b0e8"
    sha256 cellar: :any_skip_relocation, big_sur:        "76b8fe33b8afbbe62a1374165dd7c1d9cceeca923955426cc08eae979d31b0e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "de8b92e3ab10ecd4a54b63a45125903a67907df4ea7cdf6f9789f052912b1104"
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