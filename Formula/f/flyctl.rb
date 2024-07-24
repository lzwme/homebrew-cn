class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https:fly.io"
  url "https:github.comsuperflyflyctl.git",
      tag:      "v0.2.94",
      revision: "1bdffec08d15cc402927fa42eef47eec7e851dbf"
  license "Apache-2.0"
  head "https:github.comsuperflyflyctl.git", branch: "master"

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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0c6cae5fa0fa2d988fdb121c0b9c16781af56e138346903b29966271b1d4560e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0c6cae5fa0fa2d988fdb121c0b9c16781af56e138346903b29966271b1d4560e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0c6cae5fa0fa2d988fdb121c0b9c16781af56e138346903b29966271b1d4560e"
    sha256 cellar: :any_skip_relocation, sonoma:         "227d9fd936c5c7cdacc09e76412da48b9130c1f73e7c55f4b3b86e593991e5cc"
    sha256 cellar: :any_skip_relocation, ventura:        "227d9fd936c5c7cdacc09e76412da48b9130c1f73e7c55f4b3b86e593991e5cc"
    sha256 cellar: :any_skip_relocation, monterey:       "227d9fd936c5c7cdacc09e76412da48b9130c1f73e7c55f4b3b86e593991e5cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "480da0e92200eeeab049aa9630c3219bfb3e677e744178702ff6bec1ace9d4ab"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -X github.comsuperflyflyctlinternalbuildinfo.buildDate=#{time.iso8601}
      -X github.comsuperflyflyctlinternalbuildinfo.buildVersion=#{version}
      -X github.comsuperflyflyctlinternalbuildinfo.commit=#{Utils.git_short_head}
    ]
    system "go", "build", *std_go_args(ldflags:), "-tags", "production"

    bin.install_symlink "flyctl" => "fly"

    generate_completions_from_executable(bin"flyctl", "completion")
  end

  test do
    assert_match "flyctl v#{version}", shell_output("#{bin}flyctl version")

    flyctl_status = shell_output("#{bin}flyctl status 2>&1", 1)
    assert_match "Error: No access token available. Please login with 'flyctl auth login'", flyctl_status
  end
end