class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https:fly.io"
  url "https:github.comsuperflyflyctl.git",
      tag:      "v0.2.125",
      revision: "19c7e647cdb47a0673e1e523d6445651961a5a84"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "54bfeca205000c73e6b4642f78acd49c24abb60e532189ed0549eec31c36f142"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "54bfeca205000c73e6b4642f78acd49c24abb60e532189ed0549eec31c36f142"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "54bfeca205000c73e6b4642f78acd49c24abb60e532189ed0549eec31c36f142"
    sha256 cellar: :any_skip_relocation, sonoma:         "a335cf7168b566f0d7fb67a1f954bdcde0c03df38e49787b5b73efdc5f6acd26"
    sha256 cellar: :any_skip_relocation, ventura:        "a335cf7168b566f0d7fb67a1f954bdcde0c03df38e49787b5b73efdc5f6acd26"
    sha256 cellar: :any_skip_relocation, monterey:       "a335cf7168b566f0d7fb67a1f954bdcde0c03df38e49787b5b73efdc5f6acd26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b61a528c47f2c3712619a73cbbec7d5be15980b5bee0ac712faac559b4c57877"
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