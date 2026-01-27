class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.4.5",
      revision: "4caca5f55e764aa400ceafdecc5f067dbbd062d6"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "99825f90b2eb0b5d105f0cbcde8cc3e8b75f766d2c03d1715bec50fc648f489d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "99825f90b2eb0b5d105f0cbcde8cc3e8b75f766d2c03d1715bec50fc648f489d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "99825f90b2eb0b5d105f0cbcde8cc3e8b75f766d2c03d1715bec50fc648f489d"
    sha256 cellar: :any_skip_relocation, sonoma:        "3b49c5c88e8792eacae2f3ce6c0b1f72cce4922f82ed08ed6bf644bab85ba8b7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ba8e2120e6a0ce8a7be04f8ab6374c40785ad62845f09d5547da2f3100e80d5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d352bd668eb0b50f475fc055041dff74d03de0846f8d12a0f593f99b8e2fd14e"
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