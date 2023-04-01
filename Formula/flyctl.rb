class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.503",
      revision: "317a1b8fc52f226f09f15989d87ed839a633ba49"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "496327f576a9949a910bd123041e415d85975a59b9c0eb15f4078c378b73f4c1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "496327f576a9949a910bd123041e415d85975a59b9c0eb15f4078c378b73f4c1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "496327f576a9949a910bd123041e415d85975a59b9c0eb15f4078c378b73f4c1"
    sha256 cellar: :any_skip_relocation, ventura:        "a915db182f2ddb470f39caf06ac67473a3689230b2f1d05c4ce169cb895008cb"
    sha256 cellar: :any_skip_relocation, monterey:       "a915db182f2ddb470f39caf06ac67473a3689230b2f1d05c4ce169cb895008cb"
    sha256 cellar: :any_skip_relocation, big_sur:        "a915db182f2ddb470f39caf06ac67473a3689230b2f1d05c4ce169cb895008cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8f3f1841b6c7502e1411869dd6219a086e9f6ce2b9c421354022eb6fb5729b19"
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
    assert_match "Error No access token available. Please login with 'flyctl auth login'", flyctl_status
  end
end