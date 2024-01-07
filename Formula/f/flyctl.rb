class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https:fly.io"
  url "https:github.comsuperflyflyctl.git",
      tag:      "v0.1.137",
      revision: "0dff860a878e2b280f2f53ce2aaf21ce39d800c2"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "527bcd79f88b811b84d176d6da2f123e943abca3330862da51722f8047dfc298"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "527bcd79f88b811b84d176d6da2f123e943abca3330862da51722f8047dfc298"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "527bcd79f88b811b84d176d6da2f123e943abca3330862da51722f8047dfc298"
    sha256 cellar: :any_skip_relocation, sonoma:         "79033c4b09c670daa0c5a2ffe450944411352d8f46e62382f10b066dd8e9a53a"
    sha256 cellar: :any_skip_relocation, ventura:        "79033c4b09c670daa0c5a2ffe450944411352d8f46e62382f10b066dd8e9a53a"
    sha256 cellar: :any_skip_relocation, monterey:       "79033c4b09c670daa0c5a2ffe450944411352d8f46e62382f10b066dd8e9a53a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b86854e96e5a4ac3270c24ab1ac81f993dd77555fbe403244aafe93de6d07f8b"
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
    system "go", "build", *std_go_args(ldflags: ldflags), "-tags", "production"

    bin.install_symlink "flyctl" => "fly"

    generate_completions_from_executable(bin"flyctl", "completion")
  end

  test do
    assert_match "flyctl v#{version}", shell_output("#{bin}flyctl version")

    flyctl_status = shell_output("#{bin}flyctl status 2>&1", 1)
    assert_match "Error: No access token available. Please login with 'flyctl auth login'", flyctl_status
  end
end