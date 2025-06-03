class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https:fly.io"
  url "https:github.comsuperflyflyctl.git",
      tag:      "v0.3.137",
      revision: "7a200d0547f773b3892a907959878b278d04f107"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c90327150bae368d31d4823970d87fc39baaefd55dd094ccc7641e35270dd3cb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c90327150bae368d31d4823970d87fc39baaefd55dd094ccc7641e35270dd3cb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c90327150bae368d31d4823970d87fc39baaefd55dd094ccc7641e35270dd3cb"
    sha256 cellar: :any_skip_relocation, sonoma:        "f1ef6939e2cfb332a5013a0b62555ee57ad10fdbd199c39b51998c360120c8c0"
    sha256 cellar: :any_skip_relocation, ventura:       "f1ef6939e2cfb332a5013a0b62555ee57ad10fdbd199c39b51998c360120c8c0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "332ca6035c652ac0b56eaa7dc81c62694828f8d5b4c93f18894b18ec96a7f617"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ac8f9c1ab72b505713be9fc7488336cf8d83d2b51b12a4f916e407524e91a0d6"
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