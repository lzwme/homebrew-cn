class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https:fly.io"
  url "https:github.comsuperflyflyctl.git",
      tag:      "v0.2.111",
      revision: "5789248ffc4dbd218199ce483c335547f3903965"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "94e928853244a90363df42a8e79c32c3014864e4b49c3b6bea25c43a1fc9d0b7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "94e928853244a90363df42a8e79c32c3014864e4b49c3b6bea25c43a1fc9d0b7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "94e928853244a90363df42a8e79c32c3014864e4b49c3b6bea25c43a1fc9d0b7"
    sha256 cellar: :any_skip_relocation, sonoma:         "e5d16d799c5d1d61614c8879db35953fe6ff1dc3171d2b87098e6be4467dc58c"
    sha256 cellar: :any_skip_relocation, ventura:        "e5d16d799c5d1d61614c8879db35953fe6ff1dc3171d2b87098e6be4467dc58c"
    sha256 cellar: :any_skip_relocation, monterey:       "e5d16d799c5d1d61614c8879db35953fe6ff1dc3171d2b87098e6be4467dc58c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e3a897302f536abb00e95677e1c1f93a474f228176e98277143b6ffdf0aa33fc"
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