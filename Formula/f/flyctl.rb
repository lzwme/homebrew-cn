class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https:fly.io"
  url "https:github.comsuperflyflyctl.git",
      tag:      "v0.2.119",
      revision: "ec54ad94dce0b7a8c2b785090e14981e8db363e8"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "faa98abd52296194b2993230a60b11838e67382167605d52c00a513c7b2de4bc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "faa98abd52296194b2993230a60b11838e67382167605d52c00a513c7b2de4bc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "faa98abd52296194b2993230a60b11838e67382167605d52c00a513c7b2de4bc"
    sha256 cellar: :any_skip_relocation, sonoma:         "a314395c138ab19c133b7449ecc345fd3056a5a481499bd833d08285d6fc611a"
    sha256 cellar: :any_skip_relocation, ventura:        "a314395c138ab19c133b7449ecc345fd3056a5a481499bd833d08285d6fc611a"
    sha256 cellar: :any_skip_relocation, monterey:       "a314395c138ab19c133b7449ecc345fd3056a5a481499bd833d08285d6fc611a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "86d7158c4f5e55a9ae6f4225b7a15d65c626f7b967e625c739161ca221edec33"
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