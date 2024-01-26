class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https:fly.io"
  url "https:github.comsuperflyflyctl.git",
      tag:      "v0.1.146",
      revision: "81fceeabde42511cf2a585e068fe8e415322657c"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1150f95e319b5098759738c6d17acabf2519371258fe258392c77697b6772a6f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1150f95e319b5098759738c6d17acabf2519371258fe258392c77697b6772a6f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1150f95e319b5098759738c6d17acabf2519371258fe258392c77697b6772a6f"
    sha256 cellar: :any_skip_relocation, sonoma:         "b4e18c1aeb5588620e21794a0bac44b2f850e6bb88aae79c008b407945c0f065"
    sha256 cellar: :any_skip_relocation, ventura:        "b4e18c1aeb5588620e21794a0bac44b2f850e6bb88aae79c008b407945c0f065"
    sha256 cellar: :any_skip_relocation, monterey:       "b4e18c1aeb5588620e21794a0bac44b2f850e6bb88aae79c008b407945c0f065"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c236e1e4f8ab5b28a55254a4f4cab6c3abdc8ee117a2ddec5550fff0ef8bd9f"
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