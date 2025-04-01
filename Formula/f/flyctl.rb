class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https:fly.io"
  url "https:github.comsuperflyflyctl.git",
      tag:      "v0.3.95",
      revision: "e72b0699c8cd18a8f37909376be4b135e6c3576c"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "30af728c9027a0cc1267bb18cf23c95bb59db0663a89093e5bf38bba94cf13cf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "30af728c9027a0cc1267bb18cf23c95bb59db0663a89093e5bf38bba94cf13cf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "30af728c9027a0cc1267bb18cf23c95bb59db0663a89093e5bf38bba94cf13cf"
    sha256 cellar: :any_skip_relocation, sonoma:        "7e3dc025ffe24d759b5385309ec966d14a7d14f3f35ea1921c3c419caafc4817"
    sha256 cellar: :any_skip_relocation, ventura:       "7e3dc025ffe24d759b5385309ec966d14a7d14f3f35ea1921c3c419caafc4817"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "084c6245683ae255cb2b2d4b3c50ec74eeffeb554f6d4210bc1844ede2cb692d"
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