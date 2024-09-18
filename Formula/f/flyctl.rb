class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https:fly.io"
  url "https:github.comsuperflyflyctl.git",
      tag:      "v0.3.5",
      revision: "c4e44d40d1a931847c7fb15eed591e8d8596774e"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c7455195b9a17025d2ad73e6c51857ad9bc761ea0a2135bd608ef12230af18b7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c7455195b9a17025d2ad73e6c51857ad9bc761ea0a2135bd608ef12230af18b7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c7455195b9a17025d2ad73e6c51857ad9bc761ea0a2135bd608ef12230af18b7"
    sha256 cellar: :any_skip_relocation, sonoma:        "2b708b369d9acf56b2307b83684c4a508bec7551004ff767ad30d4db6db6ba02"
    sha256 cellar: :any_skip_relocation, ventura:       "2b708b369d9acf56b2307b83684c4a508bec7551004ff767ad30d4db6db6ba02"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "20169f753d4913aa186d8c7ac2285b36d684e25228490c848f1b29ef5eff05c2"
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