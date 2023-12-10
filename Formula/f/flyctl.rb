class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.1.134",
      revision: "4068ab361d741dc37df5c1b40d3adad290024f2e"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "803efa2c3a2bc230b7e3426447bf885e6d75fd3af5ba4359e834153c234d172c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "803efa2c3a2bc230b7e3426447bf885e6d75fd3af5ba4359e834153c234d172c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "803efa2c3a2bc230b7e3426447bf885e6d75fd3af5ba4359e834153c234d172c"
    sha256 cellar: :any_skip_relocation, sonoma:         "fb505c4b8a5debd8c1743c7742891f163bab1f997ee21169d8e07f7af80d1f2e"
    sha256 cellar: :any_skip_relocation, ventura:        "fb505c4b8a5debd8c1743c7742891f163bab1f997ee21169d8e07f7af80d1f2e"
    sha256 cellar: :any_skip_relocation, monterey:       "fb505c4b8a5debd8c1743c7742891f163bab1f997ee21169d8e07f7af80d1f2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9deea5ff524d5de83349a2572e9c1968cd93107e6d8b4d56b273dd6920d40412"
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