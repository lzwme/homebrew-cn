class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https:fly.io"
  url "https:github.comsuperflyflyctl.git",
      tag:      "v0.3.146",
      revision: "a7ee436384e6449ee25863d04f1b44745cda3382"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f6693ef364c6775ac644a47d4a088ea28d21ad6b67ddb10e135bc9859c78505e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f6693ef364c6775ac644a47d4a088ea28d21ad6b67ddb10e135bc9859c78505e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f6693ef364c6775ac644a47d4a088ea28d21ad6b67ddb10e135bc9859c78505e"
    sha256 cellar: :any_skip_relocation, sonoma:        "87214c9cb9ca87ec43f4ed99b15c3614f1e9b52dee09f38b30e4a41b57e2cf58"
    sha256 cellar: :any_skip_relocation, ventura:       "87214c9cb9ca87ec43f4ed99b15c3614f1e9b52dee09f38b30e4a41b57e2cf58"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b01ee6f201e539fbe97f78393db12a103eb2cea21809513222ed82d16f70da8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "69c87e5cb27601605c12152878792d3c289b6aaa6f28b78faf853ccc2dd1ac71"
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