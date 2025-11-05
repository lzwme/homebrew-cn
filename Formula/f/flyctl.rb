class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.3.207",
      revision: "15b1278bf7edb6734a925636d1269405f9569b04"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ea08f877647879c7596f6488cce8bfd2c976bffdf6af9027764f210c01282246"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ea08f877647879c7596f6488cce8bfd2c976bffdf6af9027764f210c01282246"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ea08f877647879c7596f6488cce8bfd2c976bffdf6af9027764f210c01282246"
    sha256 cellar: :any_skip_relocation, sonoma:        "c4a5da34c940b9dd9ef6e59acbd7b08261a9c12f512c35bfd029dfac0f5da9ac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e663dd085c29723aa0fb05fe29834424fe875c77202f54f893c80bcab8b606d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c08a67930d68a4fa11d635be8ca45a402d6746129b1ebae1bab7db50439ed1e"
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