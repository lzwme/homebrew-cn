class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https:fly.io"
  url "https:github.comsuperflyflyctl.git",
      tag:      "v0.3.91",
      revision: "0dc88e5ad1c42d3054d755e5d12963339409a21f"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9a0c037d7112efecb34017ac4da488cc7c52a98e63305cfc8c5370d9d99caee4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9a0c037d7112efecb34017ac4da488cc7c52a98e63305cfc8c5370d9d99caee4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9a0c037d7112efecb34017ac4da488cc7c52a98e63305cfc8c5370d9d99caee4"
    sha256 cellar: :any_skip_relocation, sonoma:        "005e2a8225f9ebc13618dd66e869ef067feeba025d03e6b4d7a5a4ca928f92de"
    sha256 cellar: :any_skip_relocation, ventura:       "005e2a8225f9ebc13618dd66e869ef067feeba025d03e6b4d7a5a4ca928f92de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "23c478224a410f910012b003c81f62f4548f44a81c10bbaf22dd83b7e180846c"
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