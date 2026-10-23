class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.4.121",
      revision: "9cca2c596271cdc163784c0dbcc68b420ade6e75"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "72804c8aeda3b4513754102c16cd6d8dd9b8983a87c6bf3926a454f6b9e0c8fd"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "72804c8aeda3b4513754102c16cd6d8dd9b8983a87c6bf3926a454f6b9e0c8fd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "72804c8aeda3b4513754102c16cd6d8dd9b8983a87c6bf3926a454f6b9e0c8fd"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "06c27dcfa11a667e9cf2f0d7ce087b39d192e7fda406f09678af873163f3633d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "d419070441f29cccb0130863a0d50a1206fc2fdaef6300c0c9cad7898d152a1f"
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