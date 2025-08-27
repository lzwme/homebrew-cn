class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.3.172",
      revision: "b389cead658c02081d3cc1384def330a54707d67"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f22e9a7d38b5d841dff0db24ae1dc1740ef97413839071ad796629267ef5c1be"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f22e9a7d38b5d841dff0db24ae1dc1740ef97413839071ad796629267ef5c1be"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f22e9a7d38b5d841dff0db24ae1dc1740ef97413839071ad796629267ef5c1be"
    sha256 cellar: :any_skip_relocation, sonoma:        "79f585900b2b3eac87183fa158e79aef752dbe2d563d8159eeb0136eef0900e1"
    sha256 cellar: :any_skip_relocation, ventura:       "79f585900b2b3eac87183fa158e79aef752dbe2d563d8159eeb0136eef0900e1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "21dd3fdb8fc0ccb82749ce143be67e59adf0f0fbe76e4c3671fa278c4da13f54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aa7b2aabdb84df64e0738acfe3102deac8f46d3e3772868ade7ad95b4f3b3e4c"
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