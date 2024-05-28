class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https:fly.io"
  url "https:github.comsuperflyflyctl.git",
      tag:      "v0.2.60",
      revision: "b380369efd87c52806b6ea132380886eb5a1f3d8"
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
    throttle 5
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "81b81b3909ec0431b1dab580ce74f93bbec730125f7419cf7492166933402022"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "81b81b3909ec0431b1dab580ce74f93bbec730125f7419cf7492166933402022"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "81b81b3909ec0431b1dab580ce74f93bbec730125f7419cf7492166933402022"
    sha256 cellar: :any_skip_relocation, sonoma:         "a1d129083a08934343eee5fca60696ddbdd9ed5cda4cd966d7a3b8433a4e4365"
    sha256 cellar: :any_skip_relocation, ventura:        "a1d129083a08934343eee5fca60696ddbdd9ed5cda4cd966d7a3b8433a4e4365"
    sha256 cellar: :any_skip_relocation, monterey:       "a1d129083a08934343eee5fca60696ddbdd9ed5cda4cd966d7a3b8433a4e4365"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "04c270c48a6c0e81dd2ba6f3a463c8c7a763da988594f88ce4036b631537f829"
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