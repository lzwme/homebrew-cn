class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https:fly.io"
  url "https:github.comsuperflyflyctl.git",
      tag:      "v0.3.106",
      revision: "75b8ea690d1cb423b7dce9d1113300ba83cbe3fd"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "449aa67512fd89beb89c5d3c91fd3e726cc13947c19451dc79054ec415bf49ad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "449aa67512fd89beb89c5d3c91fd3e726cc13947c19451dc79054ec415bf49ad"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "449aa67512fd89beb89c5d3c91fd3e726cc13947c19451dc79054ec415bf49ad"
    sha256 cellar: :any_skip_relocation, sonoma:        "aaab7aa51b38bdbe9d2676ed3c2f54eb93ca720081b0a7ab823aee8875dca101"
    sha256 cellar: :any_skip_relocation, ventura:       "aaab7aa51b38bdbe9d2676ed3c2f54eb93ca720081b0a7ab823aee8875dca101"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2991c3353ee2d34bf12bf361a12d24f6f8b41fe43c8039a59ac7f3bf003c5035"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2441c3a1d1b807323bc53b389d92d5a606b5ab04053df88cdfdcfc144c0ca655"
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