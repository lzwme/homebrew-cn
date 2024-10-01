class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https:fly.io"
  url "https:github.comsuperflyflyctl.git",
      tag:      "v0.3.13",
      revision: "ffc222f3bc56fe2602aa77ccd2cfe62010fe1ac7"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ead28e656963726ad081d213bd27969a79e10a3347ffeb140592c24bb2a74a72"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ead28e656963726ad081d213bd27969a79e10a3347ffeb140592c24bb2a74a72"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ead28e656963726ad081d213bd27969a79e10a3347ffeb140592c24bb2a74a72"
    sha256 cellar: :any_skip_relocation, sonoma:        "64d2e94cceca652e54ed25d3748354b61653771181f2c05b1bb56e4dba68e5ae"
    sha256 cellar: :any_skip_relocation, ventura:       "64d2e94cceca652e54ed25d3748354b61653771181f2c05b1bb56e4dba68e5ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9692cfc4be975aa3108b9d07302ff78f5c8359577504dffe06d6516b4ea76a45"
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