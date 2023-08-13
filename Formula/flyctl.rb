class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.1.77",
      revision: "c9880372b6bc9b3b4d3a0d0e1392c36f9b995dd9"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "77eeb7aa0f600607818e5c07808db95a2c65b4e7a186f421d5e9ce4d2b4a4882"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "77eeb7aa0f600607818e5c07808db95a2c65b4e7a186f421d5e9ce4d2b4a4882"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "77eeb7aa0f600607818e5c07808db95a2c65b4e7a186f421d5e9ce4d2b4a4882"
    sha256 cellar: :any_skip_relocation, ventura:        "d403f4e8a44b4956353338894fee2f86471f8aec8ed08be9f85968c2bf2e9d93"
    sha256 cellar: :any_skip_relocation, monterey:       "d403f4e8a44b4956353338894fee2f86471f8aec8ed08be9f85968c2bf2e9d93"
    sha256 cellar: :any_skip_relocation, big_sur:        "d403f4e8a44b4956353338894fee2f86471f8aec8ed08be9f85968c2bf2e9d93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2e22b1de36c1de0fa81f96251b7402f31e0379dba8a6ab21a8c56516c1d0f05c"
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