class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.4.55",
      revision: "a1be067df699e4faed349018883e83dac09210e8"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eb8680ace280d3883afd7b10ef04db80bbe344cd4990ef7e5694f4938215d8d1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eb8680ace280d3883afd7b10ef04db80bbe344cd4990ef7e5694f4938215d8d1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eb8680ace280d3883afd7b10ef04db80bbe344cd4990ef7e5694f4938215d8d1"
    sha256 cellar: :any_skip_relocation, sonoma:        "d4fa5903f43a10bb7eb061fcc8de76f3a4ac81d0f5de4c38d8ca32ab7694c61d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8f9ee47885caae2ebcc91594860d9a64c8298959d3036d9ca092279f436fdf6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e080b5e052a0a3363b9e42ea06bfe35767e190615d8e6e8a23ce5fee4b7a41a1"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
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