class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.4.79",
      revision: "e6225f6a889b179bb14e557e91dc976638958e98"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e2fbcebe74ad1696c1162f447671b4ce6c69a42d7035a5b0829e9c2b80847352"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e2fbcebe74ad1696c1162f447671b4ce6c69a42d7035a5b0829e9c2b80847352"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e2fbcebe74ad1696c1162f447671b4ce6c69a42d7035a5b0829e9c2b80847352"
    sha256 cellar: :any_skip_relocation, sonoma:        "4470ca64d1e6be37445a9ecda93d9db2ba73803361cb5a896fab9589c1445be1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "81b544204889a6ffc2cc5454ff456961a28b2bb87804fb878a7b0823d7fee338"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b5b8966d9d0184be71ce41d99c36988bebd2637bc3a2f14498f532ab32af4d8a"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -X github.com/superfly/flyctl/internal/buildinfo.buildDate=#{time.iso8601}
      -X github.com/superfly/flyctl/internal/buildinfo.buildVersion=#{version}
      -X github.com/superfly/flyctl/internal/buildinfo.commit=#{Utils.git_short_head}
    ]
    system "go", "build", *std_go_args(ldflags:, tags: "production")

    bin.install_symlink "flyctl" => "fly"

    %w[flyctl fly].each do |cmd|
      generate_completions_from_executable(bin/cmd, shell_parameter_format: :cobra)
    end
  end

  test do
    assert_match "flyctl v#{version}", shell_output("#{bin}/flyctl version")

    flyctl_status = shell_output("#{bin}/flyctl status 2>&1", 1)
    assert_match "Error: no access token available. Please login with 'flyctl auth login'\n", flyctl_status

    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON

    assert_match "Create a new Fly.io app", pipe_output("#{bin}/flyctl mcp server", json, 0)
  end
end