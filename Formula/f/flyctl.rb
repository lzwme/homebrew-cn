class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.4.95",
      revision: "cca99c4cc7300ea5f2c3518cd0ec0129627e0e54"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8330481cbc17d34f8b7a014915c884c0cbb369819c0841c3c22b9bb4774760b1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8330481cbc17d34f8b7a014915c884c0cbb369819c0841c3c22b9bb4774760b1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8330481cbc17d34f8b7a014915c884c0cbb369819c0841c3c22b9bb4774760b1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ddf48bac175f3adb610cba1af11ee3c01077b32c47b630621ca959a201e7f5ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6f5b2d444a7abbe9d4b5e93decae61b1a353db3fc8f3676043344a9379a82d6d"
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