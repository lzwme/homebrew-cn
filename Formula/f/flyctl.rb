class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https:fly.io"
  url "https:github.comsuperflyflyctl.git",
      tag:      "v0.3.98",
      revision: "2e6829da89d03fb6ce78c230c812d0700673a266"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fe08f7e381f135a0c1a3a39d535774062063580cff60108386cae2df1196b7d1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fe08f7e381f135a0c1a3a39d535774062063580cff60108386cae2df1196b7d1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fe08f7e381f135a0c1a3a39d535774062063580cff60108386cae2df1196b7d1"
    sha256 cellar: :any_skip_relocation, sonoma:        "ca5f43578b5cc817d254bfe8a7559d7df59e66f93134238cb8c51e259644cb0b"
    sha256 cellar: :any_skip_relocation, ventura:       "ca5f43578b5cc817d254bfe8a7559d7df59e66f93134238cb8c51e259644cb0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dcb8e0d65d7995440bd7292859a6a07ac4be2d5187d44e9ed3ebf2b989cb36cf"
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