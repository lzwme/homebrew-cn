class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https:fly.io"
  url "https:github.comsuperflyflyctl.git",
      tag:      "v0.2.88",
      revision: "f04c9c13e27f9e24d625bb2a4d64b0d5c8f94a2c"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8ed13b127c2290b7f26bec7cf94ebfd676febb7e78adad4d8bc7e3bfa0cca59c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8ed13b127c2290b7f26bec7cf94ebfd676febb7e78adad4d8bc7e3bfa0cca59c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8ed13b127c2290b7f26bec7cf94ebfd676febb7e78adad4d8bc7e3bfa0cca59c"
    sha256 cellar: :any_skip_relocation, sonoma:         "884696cc6abf896a23c43773f59b57d83ae94bca66134d7bf3915ccd745b46b2"
    sha256 cellar: :any_skip_relocation, ventura:        "884696cc6abf896a23c43773f59b57d83ae94bca66134d7bf3915ccd745b46b2"
    sha256 cellar: :any_skip_relocation, monterey:       "884696cc6abf896a23c43773f59b57d83ae94bca66134d7bf3915ccd745b46b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8dc975ad13bb26d2b7d5a910c89e8da075de478a04a6ea3f583dfe5b44137196"
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