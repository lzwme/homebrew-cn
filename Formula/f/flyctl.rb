class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.4.47",
      revision: "eb666e8fc2d597720405dcc7ee87cddbc6329c1e"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ed8457e3c4af4f9312feb4509f44dde1a947486465cb4eeb7c49a08187f36954"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ed8457e3c4af4f9312feb4509f44dde1a947486465cb4eeb7c49a08187f36954"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ed8457e3c4af4f9312feb4509f44dde1a947486465cb4eeb7c49a08187f36954"
    sha256 cellar: :any_skip_relocation, sonoma:        "bcc0608a649800bdbd2e0b56e9e09b5057cb70840f1a8a578012f946b384343e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4be91232dda5eff2965f50dc39d7c7584745436708b82e73c8c5c34b0ddf11c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b146ba4072cf58b0704e56afbd0a413847f4a980d77f0def433b590161d552e2"
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
    assert_match "Error: no access token available. Please login with 'flyctl auth login'\n", flyctl_status

    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON

    assert_match "Create a new Fly.io app", pipe_output("#{bin}/flyctl mcp server", json, 0)
  end
end