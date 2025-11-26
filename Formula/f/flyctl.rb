class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.3.223",
      revision: "36193207278bd4e10c83b369783809151290c72f"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "63acfc1b2cfa363141797db7ce0edd9080ce3200d7d5725446bf46290d5ff928"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "63acfc1b2cfa363141797db7ce0edd9080ce3200d7d5725446bf46290d5ff928"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "63acfc1b2cfa363141797db7ce0edd9080ce3200d7d5725446bf46290d5ff928"
    sha256 cellar: :any_skip_relocation, sonoma:        "ceb69e2cc78919ee836098cb1626ab389f9d33b9fcc45b3478707d598c1179d6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3fdec38edbc7ec6b5a33e39e4538b73b41ca1026b22a17611438fb676a1a3e8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d56eb1e64986f37348c8dfc5fa5a30a72f002d174401414e575193bb4f0827c3"
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