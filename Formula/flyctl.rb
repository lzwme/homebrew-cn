class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.522",
      revision: "336114ae2fe72ab94f9e6653dff56827a8bd0735"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dd86f1c43d5045cc18b55149c5af38e8fefd40c8e3c7c12c614e540c9b74c334"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dd86f1c43d5045cc18b55149c5af38e8fefd40c8e3c7c12c614e540c9b74c334"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dd86f1c43d5045cc18b55149c5af38e8fefd40c8e3c7c12c614e540c9b74c334"
    sha256 cellar: :any_skip_relocation, ventura:        "bac3ca24425a3aa8d133ad7149745460ea0b514c67ff29d3f33dc8df902d34e1"
    sha256 cellar: :any_skip_relocation, monterey:       "bac3ca24425a3aa8d133ad7149745460ea0b514c67ff29d3f33dc8df902d34e1"
    sha256 cellar: :any_skip_relocation, big_sur:        "bac3ca24425a3aa8d133ad7149745460ea0b514c67ff29d3f33dc8df902d34e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3f7c8949eef6ade1d86091f70dbce796cdd389ee6eaadc89d19d544a209a1652"
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