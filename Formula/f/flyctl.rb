class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https:fly.io"
  url "https:github.comsuperflyflyctl.git",
      tag:      "v0.3.89",
      revision: "46425b2c84dbb1c1091a41d875736de6b7904afe"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6ad8f3e111679aa3f836ff62e92e607daa11e8e83f4e111302ede43400f949ed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6ad8f3e111679aa3f836ff62e92e607daa11e8e83f4e111302ede43400f949ed"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6ad8f3e111679aa3f836ff62e92e607daa11e8e83f4e111302ede43400f949ed"
    sha256 cellar: :any_skip_relocation, sonoma:        "f0001300cb3a77152abc05183996c3726084567e93203d283d998c1a6eef5a8c"
    sha256 cellar: :any_skip_relocation, ventura:       "f0001300cb3a77152abc05183996c3726084567e93203d283d998c1a6eef5a8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6f3471c8853127adeaafd56547fa7158810a39560a3818f10d5eedcf3cc50d08"
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