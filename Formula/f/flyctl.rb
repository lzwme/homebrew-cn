class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https:fly.io"
  url "https:github.comsuperflyflyctl.git",
      tag:      "v0.3.94",
      revision: "161e70d52c6e6670534484e4af74425aad95ff6e"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b477d2bb4f0b4816fe2a5dea9383756ef2507980323da35962c15b3b42646dfa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b477d2bb4f0b4816fe2a5dea9383756ef2507980323da35962c15b3b42646dfa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b477d2bb4f0b4816fe2a5dea9383756ef2507980323da35962c15b3b42646dfa"
    sha256 cellar: :any_skip_relocation, sonoma:        "3a4fe3b5cba8498ccd58ced44ab9d3fff8cdd59e321e26dbe95eb5fef6775e64"
    sha256 cellar: :any_skip_relocation, ventura:       "3a4fe3b5cba8498ccd58ced44ab9d3fff8cdd59e321e26dbe95eb5fef6775e64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "adddab3f06b3fd524b6c10c6040575621754f03210e043a7dcd5e98103ce7fbe"
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