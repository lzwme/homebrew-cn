class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.1.127",
      revision: "a1c60ede67a656d0ef931f12042c2d34119cefe5"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9800def8f3e9f63b9454e68cbf1014656850dd30cb30021bcd1c9f3f5465f19a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9800def8f3e9f63b9454e68cbf1014656850dd30cb30021bcd1c9f3f5465f19a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9800def8f3e9f63b9454e68cbf1014656850dd30cb30021bcd1c9f3f5465f19a"
    sha256 cellar: :any_skip_relocation, sonoma:         "239d038406800c948ec6ad2ace693b75f3042f2a45bf278a51d53cb2d7d68790"
    sha256 cellar: :any_skip_relocation, ventura:        "239d038406800c948ec6ad2ace693b75f3042f2a45bf278a51d53cb2d7d68790"
    sha256 cellar: :any_skip_relocation, monterey:       "239d038406800c948ec6ad2ace693b75f3042f2a45bf278a51d53cb2d7d68790"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2bb427c8568adcecf2eac658cd60903228f487d0b946f91adb8c254b5515afec"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -X github.com/superfly/flyctl/internal/buildinfo.buildDate=#{time.iso8601}
      -X github.com/superfly/flyctl/internal/buildinfo.buildVersion=#{version}
      -X github.com/superfly/flyctl/internal/buildinfo.commit=#{Utils.git_short_head}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "-tags", "production"

    bin.install_symlink "flyctl" => "fly"

    generate_completions_from_executable(bin/"flyctl", "completion")
  end

  test do
    assert_match "flyctl v#{version}", shell_output("#{bin}/flyctl version")

    flyctl_status = shell_output("#{bin}/flyctl status 2>&1", 1)
    assert_match "Error: No access token available. Please login with 'flyctl auth login'", flyctl_status
  end
end