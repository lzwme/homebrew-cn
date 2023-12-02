class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.1.131",
      revision: "b530c016ec97c797ed68a9842796034eb157b883"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  # Upstream tags versions like `v0.1.92` and `v2023.9.8` but, as of writing,
  # they only create releases for the former and those are the versions we use
  # in this formula. We could omit the date-based versions using a regex but
  # this uses the `GithubLatest` strategy, as the upstream repository also
  # contains over a thousand tags (and growing).
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "90dc8204acd310b0148567f44884f9c8dd6795d875f6c1ac347765a579c17207"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "90dc8204acd310b0148567f44884f9c8dd6795d875f6c1ac347765a579c17207"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "90dc8204acd310b0148567f44884f9c8dd6795d875f6c1ac347765a579c17207"
    sha256 cellar: :any_skip_relocation, sonoma:         "dab0d2c886c08e6638ab1eadc2ed5544db2519bfa16b4b6895ea6bdb7526f8ba"
    sha256 cellar: :any_skip_relocation, ventura:        "dab0d2c886c08e6638ab1eadc2ed5544db2519bfa16b4b6895ea6bdb7526f8ba"
    sha256 cellar: :any_skip_relocation, monterey:       "dab0d2c886c08e6638ab1eadc2ed5544db2519bfa16b4b6895ea6bdb7526f8ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a13249c78b39387138e9414a83462dfc0dfe03c07643f6dbcacbe74dc3d2bb2c"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -X github.com/superfly/flyctl/internal/buildinfo.buildDate=#{time.iso8601}
      -X github.com/superfly/flyctl/internal/buildinfo.buildVersion=#{version}
      -X github.com/superfly/flyctl/internal/buildinfo.commit=#{Utils.git_short_head}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "-tags", "production"

    bin.install_symlink "flyctl" => "fly"

    generate_completions_from_executable(bin/"flyctl", "completion")
  end

  test do
    assert_match "flyctl v#{version}", shell_output("#{bin}/flyctl version")

    flyctl_status = shell_output("#{bin}/flyctl status 2>&1", 1)
    assert_match "Error: No access token available. Please login with 'flyctl auth login'", flyctl_status
  end
end