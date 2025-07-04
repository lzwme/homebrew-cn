class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https:fly.io"
  url "https:github.comsuperflyflyctl.git",
      tag:      "v0.3.149",
      revision: "2c142c1141c084c54311d00923ae1c00be4d9407"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "76b5c095c40fe04881909732c3278a6a6e73902e91a517ecdbc7e8b629ea02e5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "76b5c095c40fe04881909732c3278a6a6e73902e91a517ecdbc7e8b629ea02e5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "76b5c095c40fe04881909732c3278a6a6e73902e91a517ecdbc7e8b629ea02e5"
    sha256 cellar: :any_skip_relocation, sonoma:        "cdcfaa14b12d8704faf6a83b52ab29cf0fa37283f4e715ad1b14eb33b9000048"
    sha256 cellar: :any_skip_relocation, ventura:       "cdcfaa14b12d8704faf6a83b52ab29cf0fa37283f4e715ad1b14eb33b9000048"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b9082b096eece51b2da366653dd2af9d0efabe3edfa90a490b31a477518dad70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9deaae2152bd6da04976aef68ebe64424a03f14f7d3c81e2e448b9be270c2e88"
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