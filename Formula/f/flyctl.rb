class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.3.205",
      revision: "eefac469b8b39c1877aae901e61fee701a93a645"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b906d696b6dfa41e2b29bf96d2ea36b1d5754d0dfc1efa2f1178e4f41184bcd0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b906d696b6dfa41e2b29bf96d2ea36b1d5754d0dfc1efa2f1178e4f41184bcd0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b906d696b6dfa41e2b29bf96d2ea36b1d5754d0dfc1efa2f1178e4f41184bcd0"
    sha256 cellar: :any_skip_relocation, sonoma:        "0aece398fe1448cb240da8fe51835f73b24c2fb3e956fcec9239a1adc78be5c5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "86f08da8b1591febd68d55e5c2275ad8fc2b3db74fd2d06be2852c4ae45def54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3cd57b356b493561154bf46baf4b1fcb154d9a4be12355b85a06e3bcc9896cda"
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