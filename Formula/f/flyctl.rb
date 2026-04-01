class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.4.29",
      revision: "c5059d177859cf6dfdd5538d59ff8313d01fce7d"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "93643dc2a1ed8b6eb162e43a1e2a6ef8feef6882f4ac0f06c2136341d69590f3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "93643dc2a1ed8b6eb162e43a1e2a6ef8feef6882f4ac0f06c2136341d69590f3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "93643dc2a1ed8b6eb162e43a1e2a6ef8feef6882f4ac0f06c2136341d69590f3"
    sha256 cellar: :any_skip_relocation, sonoma:        "a9752923e7740a1e19da7a11accd335386a4f8865c9b4f7c643295a09d4eeace"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7e5e1d482a7a051c5a5dde3955802845be1c15e7427f65589be6d3b1d288b840"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0968a6b8d7512f5b69d10b20090cc7ab57871f4db7bf0a86228127f0e7977e12"
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