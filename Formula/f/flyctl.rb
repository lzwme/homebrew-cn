class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https:fly.io"
  url "https:github.comsuperflyflyctl.git",
      tag:      "v0.1.149",
      revision: "e17fb400eb8ff46ca073789e59fa985362ed1889"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "19e2c6f9eb4b803ccc55b0e0b805d80c8c19c2a14b20a0f820d0053328c1e2ef"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "19e2c6f9eb4b803ccc55b0e0b805d80c8c19c2a14b20a0f820d0053328c1e2ef"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "19e2c6f9eb4b803ccc55b0e0b805d80c8c19c2a14b20a0f820d0053328c1e2ef"
    sha256 cellar: :any_skip_relocation, sonoma:         "9c45ff55612ee80cdeac652c290da31c6631194215e62e2fa64047d70602e86c"
    sha256 cellar: :any_skip_relocation, ventura:        "9c45ff55612ee80cdeac652c290da31c6631194215e62e2fa64047d70602e86c"
    sha256 cellar: :any_skip_relocation, monterey:       "9c45ff55612ee80cdeac652c290da31c6631194215e62e2fa64047d70602e86c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3e3b54e6ea08523085aeeec76252a2e62e50277ebe6227660b7edd5fbba56074"
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
    system "go", "build", *std_go_args(ldflags: ldflags), "-tags", "production"

    bin.install_symlink "flyctl" => "fly"

    generate_completions_from_executable(bin"flyctl", "completion")
  end

  test do
    assert_match "flyctl v#{version}", shell_output("#{bin}flyctl version")

    flyctl_status = shell_output("#{bin}flyctl status 2>&1", 1)
    assert_match "Error: No access token available. Please login with 'flyctl auth login'", flyctl_status
  end
end