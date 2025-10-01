class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.3.189",
      revision: "ab0f33f96407173c419ab56dd166cf26ff6eae6e"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c2a0be454fb66e4b3751e7514d61e04664c11f73aa6bea2e6ece9fab5a584323"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c2a0be454fb66e4b3751e7514d61e04664c11f73aa6bea2e6ece9fab5a584323"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c2a0be454fb66e4b3751e7514d61e04664c11f73aa6bea2e6ece9fab5a584323"
    sha256 cellar: :any_skip_relocation, sonoma:        "92454ae409613ef167d25f801f633cf62ee4b34bd678b51296de90243c8526ba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "27f62527ecd2f110b86e08fc378dbf0f88aaf350cb9d52ee96b8b280d8d37d1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9920dec188562c3294c14b411dd806eea2c4e94673dc1af568530893f43c3f56"
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