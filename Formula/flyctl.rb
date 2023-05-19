class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.1.8",
      revision: "8c7a3494a027b7ebfe503a516d0080c5ef8080e1"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4980561d7615a9c508e6e881cae8bb1a655aa92fc84da0b7b4fcbc78c5ccc52d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4980561d7615a9c508e6e881cae8bb1a655aa92fc84da0b7b4fcbc78c5ccc52d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4980561d7615a9c508e6e881cae8bb1a655aa92fc84da0b7b4fcbc78c5ccc52d"
    sha256 cellar: :any_skip_relocation, ventura:        "a748c9246e4edf0b4c7fd8fd33f462260a4806830b79e2e300eae61ced7dc6f3"
    sha256 cellar: :any_skip_relocation, monterey:       "a748c9246e4edf0b4c7fd8fd33f462260a4806830b79e2e300eae61ced7dc6f3"
    sha256 cellar: :any_skip_relocation, big_sur:        "a748c9246e4edf0b4c7fd8fd33f462260a4806830b79e2e300eae61ced7dc6f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1a3ed87e3534b0c9f24cc95179fad4011ee9ce1c4a71893da7b50a318c63333d"
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