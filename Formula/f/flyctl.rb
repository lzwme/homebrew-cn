class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.4.19",
      revision: "c12bb496234c8402a0387821367be315a506e54a"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "79720e3a44e6b3a6dc7969925f1f54687aebaa959d4c50abe9479153f0c73e8a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "79720e3a44e6b3a6dc7969925f1f54687aebaa959d4c50abe9479153f0c73e8a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "79720e3a44e6b3a6dc7969925f1f54687aebaa959d4c50abe9479153f0c73e8a"
    sha256 cellar: :any_skip_relocation, sonoma:        "99220caf6fd1c131d75659de596629b267c7890a4993fbf0f259d52c078d6a08"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "449962219974106b59420d0ab513b4b815fb8f65456583e784ddb10b1ed216fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a134f3c97cb7a49ab2d54d07c7150a9b60bd9fccaed5cdd4ff48d6e979cbb805"
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