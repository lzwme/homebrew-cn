class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.4.76",
      revision: "92cc8787ea24308129f4c3319822a2bf4acbbb53"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e0dc7764b07d125b07719315224f51b948f1458ec40d8a480e6256128a4af4e5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e0dc7764b07d125b07719315224f51b948f1458ec40d8a480e6256128a4af4e5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e0dc7764b07d125b07719315224f51b948f1458ec40d8a480e6256128a4af4e5"
    sha256 cellar: :any_skip_relocation, sonoma:        "bdee9942bac9f40ae73acad5c7ba0a9455fa753621f4920c018a86bb92a5d12c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "20eb4472b197c323b9f04b1334a8e30244e3a810382e531b12dfbc57a7fbbc97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6fad3028736476474ca8ca2c141dd689ec3c314611487d365f32bf096d1e8d89"
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