class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https:fly.io"
  url "https:github.comsuperflyflyctl.git",
      tag:      "v0.3.23",
      revision: "ee2134fbbf34cc4d4c161a23f8023482e897301a"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "908f6365c4eb6a4f55720f1b0464182c123591bce0c87963b8e13171217ded45"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "908f6365c4eb6a4f55720f1b0464182c123591bce0c87963b8e13171217ded45"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "908f6365c4eb6a4f55720f1b0464182c123591bce0c87963b8e13171217ded45"
    sha256 cellar: :any_skip_relocation, sonoma:        "b1ffce0c26f54579b22e48ee0a4a73370f54e57dc75b276381dc0e3a93b3006c"
    sha256 cellar: :any_skip_relocation, ventura:       "b1ffce0c26f54579b22e48ee0a4a73370f54e57dc75b276381dc0e3a93b3006c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c75675e1333f11fde84891f271b8892d59938e0c789be0469ea34ce8b9ee500d"
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