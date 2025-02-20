class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https:fly.io"
  url "https:github.comsuperflyflyctl.git",
      tag:      "v0.3.84",
      revision: "a2ac21a3cb47000b650b12fcd4cedb493a925c6d"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2d6e8a79258452ecf161e32e89847785360b52cf3fbe936b1ebd820ef83d5c0e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2d6e8a79258452ecf161e32e89847785360b52cf3fbe936b1ebd820ef83d5c0e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2d6e8a79258452ecf161e32e89847785360b52cf3fbe936b1ebd820ef83d5c0e"
    sha256 cellar: :any_skip_relocation, sonoma:        "e34d6b9ebfcfa7a9cdc2502db50440594051a9f8c1bd0fb4a39217a2d869fc9f"
    sha256 cellar: :any_skip_relocation, ventura:       "e34d6b9ebfcfa7a9cdc2502db50440594051a9f8c1bd0fb4a39217a2d869fc9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "09bb78ac43682dad1b6483d03f2e1f6be152f4bcb7fbc565101d89ceaa81ccb2"
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
    generate_completions_from_executable(bin"fly", "completion")
  end

  test do
    assert_match "flyctl v#{version}", shell_output("#{bin}flyctl version")

    flyctl_status = shell_output("#{bin}flyctl status 2>&1", 1)
    assert_match "Error: No access token available. Please login with 'flyctl auth login'", flyctl_status
  end
end