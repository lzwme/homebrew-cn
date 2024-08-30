class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https:fly.io"
  url "https:github.comsuperflyflyctl.git",
      tag:      "v0.2.124",
      revision: "790bb3b2c4536d41c6f96b88bcd87a95486ff5ea"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4d260a92820bf9ebcae2d1aa66b833f8945124919d8c3e2a6364587c9dd4ce7e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4d260a92820bf9ebcae2d1aa66b833f8945124919d8c3e2a6364587c9dd4ce7e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4d260a92820bf9ebcae2d1aa66b833f8945124919d8c3e2a6364587c9dd4ce7e"
    sha256 cellar: :any_skip_relocation, sonoma:         "c057c7880aef09b779050250cf684268e08e63d5b9e0961453f03c1d7de5bd34"
    sha256 cellar: :any_skip_relocation, ventura:        "c057c7880aef09b779050250cf684268e08e63d5b9e0961453f03c1d7de5bd34"
    sha256 cellar: :any_skip_relocation, monterey:       "c057c7880aef09b779050250cf684268e08e63d5b9e0961453f03c1d7de5bd34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6fea3bcc000952eb52d7035344d5ab1ebe470b313e96a3bbb5beaa20f438e5fd"
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