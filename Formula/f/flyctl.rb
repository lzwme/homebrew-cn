class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.4.24",
      revision: "5b89dab93a82f1cb7d9fca07085dad592d2e4d44"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b3dc14fa4d21fd8b5e53d5862d8163ef89c88080dceabc36ef7b43cb2059ef43"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b3dc14fa4d21fd8b5e53d5862d8163ef89c88080dceabc36ef7b43cb2059ef43"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b3dc14fa4d21fd8b5e53d5862d8163ef89c88080dceabc36ef7b43cb2059ef43"
    sha256 cellar: :any_skip_relocation, sonoma:        "dc70408979b6b3edf79b4efdce7199c41163c822362a44a674fa1391d279c9af"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8439206506b08b65799db7edcc517dbcc865dc23c961050b44966a47dc0056e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "49e304ec7993880b5045c7a357c99384d0e3ad20d3d105cf1d599dd10919eb6d"
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