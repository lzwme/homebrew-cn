class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.4.77",
      revision: "c69977d9c742441ce4c7d8d6880809a90d8e4f56"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b6714035a9cfc5673098ff70813e088fd6e1557e1d2a420a9ef90e493d0885cc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b6714035a9cfc5673098ff70813e088fd6e1557e1d2a420a9ef90e493d0885cc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b6714035a9cfc5673098ff70813e088fd6e1557e1d2a420a9ef90e493d0885cc"
    sha256 cellar: :any_skip_relocation, sonoma:        "e7c055ad6ef8abeacf538fe2a89668fd43a75819e4dcb707434d887f82dafd0d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9eecb2c71ab15754406ed66cc78b577250ea39f251f2d2873c767f719b4725d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "29111673c87f72f63105d5791264e88078701d5e594e2277a45a62331bc9c034"
  end

  depends_on "go" => :build

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