class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.4.37",
      revision: "dc77d940e40da4faec517c78e5582b8297967ba2"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "60d67344f5b5dd4e89a9e1213e3b589dbe517031484b298de8529cdea9d98ce7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "60d67344f5b5dd4e89a9e1213e3b589dbe517031484b298de8529cdea9d98ce7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "60d67344f5b5dd4e89a9e1213e3b589dbe517031484b298de8529cdea9d98ce7"
    sha256 cellar: :any_skip_relocation, sonoma:        "c9d49b132c4d75b56aa67327a9d0f8363780051951ec5bfd18adf93f400a9f1b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "339145ae6ab040d8c87132f6841e8d5e61b2cfc33efefcaed8c900cab1717e50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1a828d4cbd7d83b15cc694f1f6663a7777cf8c9b26716bdb52395f005ea5cb46"
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