class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.4.73",
      revision: "2f4eddd7b07cee9c3a718fba852122d7dee55d49"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a9c8df420782c396f5a45cf0325a2b3fa2c1b1e988f820ed397c1d96218e86df"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a9c8df420782c396f5a45cf0325a2b3fa2c1b1e988f820ed397c1d96218e86df"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a9c8df420782c396f5a45cf0325a2b3fa2c1b1e988f820ed397c1d96218e86df"
    sha256 cellar: :any_skip_relocation, sonoma:        "7c2d4a3204e16903fc7219d88fc810b0a7700a672d1cc7ebd90bb22d46613554"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8266b05e70f4705259edb70e29a2e6ac559ed82ffce281a6333b944d7ef23a02"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "99b571b25e043e569a4fc1a995707258a428dbb4d5ef613323badf7e00957e7e"
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