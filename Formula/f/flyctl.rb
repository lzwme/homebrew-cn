class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https:fly.io"
  url "https:github.comsuperflyflyctl.git",
      tag:      "v0.2.42",
      revision: "44aedf5b21a71b0c086d4603d2522f71e2908c61"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "959ce0ec35801e64c4044a54d38891e6d35d6ffda3b88c7f404b1991167d6e2c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "959ce0ec35801e64c4044a54d38891e6d35d6ffda3b88c7f404b1991167d6e2c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "959ce0ec35801e64c4044a54d38891e6d35d6ffda3b88c7f404b1991167d6e2c"
    sha256 cellar: :any_skip_relocation, sonoma:         "c7c45244e900d9eb91593340cff6e228294e887d09980c7828525de63feb5cd7"
    sha256 cellar: :any_skip_relocation, ventura:        "c7c45244e900d9eb91593340cff6e228294e887d09980c7828525de63feb5cd7"
    sha256 cellar: :any_skip_relocation, monterey:       "c7c45244e900d9eb91593340cff6e228294e887d09980c7828525de63feb5cd7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "efc1266055ce9701dfcf60654fd71c44c7ccbb9a042f8f3f6ae67a80722e34f2"
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