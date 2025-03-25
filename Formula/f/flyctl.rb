class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https:fly.io"
  url "https:github.comsuperflyflyctl.git",
      tag:      "v0.3.92",
      revision: "a2eaac068c589cf930ccc6bab8e222961333ad60"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "abd697ee32739d35767c40316f7e4295aef69f16f97f8d4d5113a326b42dca28"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "abd697ee32739d35767c40316f7e4295aef69f16f97f8d4d5113a326b42dca28"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "abd697ee32739d35767c40316f7e4295aef69f16f97f8d4d5113a326b42dca28"
    sha256 cellar: :any_skip_relocation, sonoma:        "87503c8fdb4389fcc8da5ab539981630dc5be64098210a88eef50227d42bf64c"
    sha256 cellar: :any_skip_relocation, ventura:       "87503c8fdb4389fcc8da5ab539981630dc5be64098210a88eef50227d42bf64c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "18ecd9ec2202a5d5fcc5f93877b44868a190e66fcdd1617b383cef23eeea9a73"
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
    system "go", "build", *std_go_args(ldflags:, tags: "production")

    bin.install_symlink "flyctl" => "fly"

    generate_completions_from_executable(bin"flyctl", "completion")
    generate_completions_from_executable(bin"fly", "completion")
  end

  test do
    assert_match "flyctl v#{version}", shell_output("#{bin}flyctl version")

    flyctl_status = shell_output("#{bin}flyctl status 2>&1", 1)
    assert_match "Error: No access token available. Please login with 'flyctl auth login'", flyctl_status
  end
end