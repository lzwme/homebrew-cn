class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.4.84",
      revision: "1b52b15dc49bbb21e6133009101a70af1e31e9ee"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9db7589f5054a4111678ef0f81c59c2a8ec7ff723afbe24586cdf55ae27ae995"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9db7589f5054a4111678ef0f81c59c2a8ec7ff723afbe24586cdf55ae27ae995"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9db7589f5054a4111678ef0f81c59c2a8ec7ff723afbe24586cdf55ae27ae995"
    sha256 cellar: :any_skip_relocation, sonoma:        "0491b3b55c0b44402c39a960e5e3747c3b9989f0d72f0a3e6a3345aeae31aadb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b6bf2e164946b575626efe1d5517f20eb7d34c6ba956c2d1a87fc5c02097f613"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6291e1f04340be279ea1e2716f9fb963f4feb22d2fc75df14823ee39fda16de4"
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