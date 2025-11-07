class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.3.209",
      revision: "9383e01c8cc7e0482b2bd81d093eb6652d92dc76"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "371fef015d05c7d6f77bf69a70f584a4ec54bbd1ea62b8f4f21b7db4d9adbbe4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "371fef015d05c7d6f77bf69a70f584a4ec54bbd1ea62b8f4f21b7db4d9adbbe4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "371fef015d05c7d6f77bf69a70f584a4ec54bbd1ea62b8f4f21b7db4d9adbbe4"
    sha256 cellar: :any_skip_relocation, sonoma:        "ea10d92670edef81f485a082dd64f0539c8c152d32efd94584f4f59be167f9fb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "911874d33e70446b2fa58fc97dad38c3559d9f004203c6bde5e92347766b4713"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c0ac4e66891ea55c03b8c0bc01c7a1ab0a17e04aea484bd0cfcfd2e818545e61"
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

    generate_completions_from_executable(bin/"flyctl", "completion")
    generate_completions_from_executable(bin/"fly", "completion")
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