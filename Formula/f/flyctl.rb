class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.4.53",
      revision: "e88a7100a92b9aaaacf0b1b1506ca772cd974041"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d5127c3d81ce9600ec2c49b410848e03a839fe00dba0230af56d4bc85fef0185"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d5127c3d81ce9600ec2c49b410848e03a839fe00dba0230af56d4bc85fef0185"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d5127c3d81ce9600ec2c49b410848e03a839fe00dba0230af56d4bc85fef0185"
    sha256 cellar: :any_skip_relocation, sonoma:        "d7a8caf3342aa13ea93d9ab09674a3a6054f23c0418dda858da843e02e0bf5b3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d1b76497b8990c1d8018ba4a558e43896ee0d3b47da6cefa402325f6bb40d9c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "33c586b6cc34fa6f31806a7fb308094fb4c83ae16ceeeeb8b11bf787b37a9bf8"
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