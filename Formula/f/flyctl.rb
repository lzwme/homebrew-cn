class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.4.92",
      revision: "17564afc1d1fd4bade270bc34dfc864758fdfa83"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1654105e0d65b19802e51c1df87c58113bc358380409ba95d2c99614011c5ab1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1654105e0d65b19802e51c1df87c58113bc358380409ba95d2c99614011c5ab1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1654105e0d65b19802e51c1df87c58113bc358380409ba95d2c99614011c5ab1"
    sha256 cellar: :any_skip_relocation, sonoma:        "a1628516a08fd17e0b0afbd00cc820c20c3edf3e1002c168f73ef113776eda09"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "664f1f880e7cdd3fa2b853425a1a50eeb2b5479ba3475e1318c30544fa6e5190"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "655aeebe638a32c67092f528f401b9e37f198ba92c24cc118914604e5c5f3818"
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