class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.3.178",
      revision: "a9d85fff0a6182ab5b74d02b4d7c7f01856fe243"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c41a8ca49c8b7b1f502b7f4724d3dd4fddea09ed429dca030a9534065d63b5a3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c41a8ca49c8b7b1f502b7f4724d3dd4fddea09ed429dca030a9534065d63b5a3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c41a8ca49c8b7b1f502b7f4724d3dd4fddea09ed429dca030a9534065d63b5a3"
    sha256 cellar: :any_skip_relocation, sonoma:        "5078125c9b1fdd90e14b10b39782d1c407fac7410e4fa962a4e2a809a09baf99"
    sha256 cellar: :any_skip_relocation, ventura:       "5078125c9b1fdd90e14b10b39782d1c407fac7410e4fa962a4e2a809a09baf99"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e63ba488393b461a2e859ad3e93c0dddfd56ecbb6e803fa1f8aea050dbdc2c11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fcff102dab49fe6b69aaec66522dca2a168483d5f1d70713cf276f0f2f4d44df"
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