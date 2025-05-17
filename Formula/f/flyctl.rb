class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https:fly.io"
  url "https:github.comsuperflyflyctl.git",
      tag:      "v0.3.124",
      revision: "cfb48462d0b5f634f85ba8019fdbf1aa7bb0152a"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9b689188af3fe505a7e08148410cadac5614aac8a3825b42c10b29736da04cca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9b689188af3fe505a7e08148410cadac5614aac8a3825b42c10b29736da04cca"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9b689188af3fe505a7e08148410cadac5614aac8a3825b42c10b29736da04cca"
    sha256 cellar: :any_skip_relocation, sonoma:        "472f88af6f1ea79ee0009aa93c888ae228c9124d99d9ed68b71f02c59a0ed099"
    sha256 cellar: :any_skip_relocation, ventura:       "472f88af6f1ea79ee0009aa93c888ae228c9124d99d9ed68b71f02c59a0ed099"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "724d057946eb7791042877b69a8023985481bd66dc1e90002d736d58c5c64054"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "60df7f41e7cb4ef83ad38833301b88fe45c34e03fd4bf5b7bf3b6a3e77dcf742"
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