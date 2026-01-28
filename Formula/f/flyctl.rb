class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.4.6",
      revision: "4fd60abf9c13af3f0055008a6b1da8dba398ed69"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1194f45fd87c8d7cbd0a5cf66288478e4ceb4d6020cdad7bfffbbfbf4ceaff04"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1194f45fd87c8d7cbd0a5cf66288478e4ceb4d6020cdad7bfffbbfbf4ceaff04"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1194f45fd87c8d7cbd0a5cf66288478e4ceb4d6020cdad7bfffbbfbf4ceaff04"
    sha256 cellar: :any_skip_relocation, sonoma:        "e1f16a600ef6f804818140b54cb04cba628aa3e9d0d4ae94db630a499643c94d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e5d873e18366a8f9a35ad3195b3688397adea3f9ca26eab9f5a2f4be50105305"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a97fab2e780c6d2fb0c6b5de8d59e233a2b220e477db8d6742a9978a6476a3a9"
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
    assert_match "Error: No access token available. Please login with 'flyctl auth login'", flyctl_status

    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON

    assert_match "Create a new Fly.io app", pipe_output("#{bin}/flyctl mcp server", json, 0)
  end
end