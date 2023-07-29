class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.1.66",
      revision: "01075166a03c73f81747a0bf55dc070e7e4a6c1f"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cf2a14c4e3af09ce2ac42363dbe2d69063aa0db5bcf1f9bda58f17ae99dbe784"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cf2a14c4e3af09ce2ac42363dbe2d69063aa0db5bcf1f9bda58f17ae99dbe784"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cf2a14c4e3af09ce2ac42363dbe2d69063aa0db5bcf1f9bda58f17ae99dbe784"
    sha256 cellar: :any_skip_relocation, ventura:        "3ecf4aa577ef7f5f2c8c4bd77757e98a2e2e0cfd45db006a5839ce3cce735b41"
    sha256 cellar: :any_skip_relocation, monterey:       "3ecf4aa577ef7f5f2c8c4bd77757e98a2e2e0cfd45db006a5839ce3cce735b41"
    sha256 cellar: :any_skip_relocation, big_sur:        "3ecf4aa577ef7f5f2c8c4bd77757e98a2e2e0cfd45db006a5839ce3cce735b41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c5b63bed8b1921feb9cff96d87de96a41b697fafcf14e6cb9e5ecfa97519aac"
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