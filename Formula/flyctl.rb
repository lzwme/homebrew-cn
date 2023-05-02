class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.549",
      revision: "59ee55839f9d1ecf05f4789e26955e47ea720ee4"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "48d18a056dc2a1c49e5dc00e0f475b173aceab79905af1b032f469774b539da0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "48d18a056dc2a1c49e5dc00e0f475b173aceab79905af1b032f469774b539da0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "48d18a056dc2a1c49e5dc00e0f475b173aceab79905af1b032f469774b539da0"
    sha256 cellar: :any_skip_relocation, ventura:        "3052a7e23dbae5b6c1a5e4359f541940085e385eeda8c9e2608f2327b99f8d83"
    sha256 cellar: :any_skip_relocation, monterey:       "3052a7e23dbae5b6c1a5e4359f541940085e385eeda8c9e2608f2327b99f8d83"
    sha256 cellar: :any_skip_relocation, big_sur:        "3052a7e23dbae5b6c1a5e4359f541940085e385eeda8c9e2608f2327b99f8d83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9cef36ea0ffaf8e76f63c7ed7db3688b69d0704201c472e5dfad3235d257f08f"
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