class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https:fly.io"
  url "https:github.comsuperflyflyctl.git",
      tag:      "v0.2.3",
      revision: "1195da2f607f3797356b18dc4a0ffc40a91f55ac"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d151a31ffb000c9e19cb5792d08bdfd8d130826e3b10b9c940b1561b897e9f91"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d151a31ffb000c9e19cb5792d08bdfd8d130826e3b10b9c940b1561b897e9f91"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d151a31ffb000c9e19cb5792d08bdfd8d130826e3b10b9c940b1561b897e9f91"
    sha256 cellar: :any_skip_relocation, sonoma:         "280f76a9b5f1cdfa656953c87abd53fb9b468febf37a8e8e94f2c26a0482bda3"
    sha256 cellar: :any_skip_relocation, ventura:        "280f76a9b5f1cdfa656953c87abd53fb9b468febf37a8e8e94f2c26a0482bda3"
    sha256 cellar: :any_skip_relocation, monterey:       "280f76a9b5f1cdfa656953c87abd53fb9b468febf37a8e8e94f2c26a0482bda3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8e08d6cd7c8f042b309330e770ab0623dcddc4001e819e2c039d19f72ff639ff"
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