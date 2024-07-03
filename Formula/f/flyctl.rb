class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https:fly.io"
  url "https:github.comsuperflyflyctl.git",
      tag:      "v0.2.80",
      revision: "b97668a25cf27445084c0fc15007b862ec2c5090"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "61b4634d3bc0c959fdb70f0b1a52dabb9f372e96c54aa3960871f2017d6c929f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "61b4634d3bc0c959fdb70f0b1a52dabb9f372e96c54aa3960871f2017d6c929f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "61b4634d3bc0c959fdb70f0b1a52dabb9f372e96c54aa3960871f2017d6c929f"
    sha256 cellar: :any_skip_relocation, sonoma:         "87f510a6f1400fa5eb788c44ca3d49cd4c7406c01c07a65ba20e692257e064f9"
    sha256 cellar: :any_skip_relocation, ventura:        "87f510a6f1400fa5eb788c44ca3d49cd4c7406c01c07a65ba20e692257e064f9"
    sha256 cellar: :any_skip_relocation, monterey:       "87f510a6f1400fa5eb788c44ca3d49cd4c7406c01c07a65ba20e692257e064f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d1c0b029a0cd9e299314880f23e9ce68bf6f19c5fb1ffbef961fac934dfaf8dd"
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