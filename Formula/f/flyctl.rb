class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.4.117",
      revision: "9068e6f4631c92f168476a9883df020d0ce12cd9"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3581d23ed9bc0d21a1666d66d02458f80d18d017a0ce9d47aec0c41fb7ebd926"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3581d23ed9bc0d21a1666d66d02458f80d18d017a0ce9d47aec0c41fb7ebd926"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3581d23ed9bc0d21a1666d66d02458f80d18d017a0ce9d47aec0c41fb7ebd926"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8090b24255ecd4da3aed1477e00e54a18e55d369ffe9761e6700a44c924119ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "b42f52938e4bd23c059f583cfce97e9a9a426b061b2c8f04590c6ada0f219e61"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
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