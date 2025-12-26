class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.4.0",
      revision: "641eb1c8b884eb191d574de8e11b8423e86e3260"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9f71f9e7e99a1ea7703567b5905acfbf77916573298c2f1c7b0ded5e626c6be9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9f71f9e7e99a1ea7703567b5905acfbf77916573298c2f1c7b0ded5e626c6be9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9f71f9e7e99a1ea7703567b5905acfbf77916573298c2f1c7b0ded5e626c6be9"
    sha256 cellar: :any_skip_relocation, sonoma:        "01f6e6729fd7a275b80758ee4f493fd9dd0fba0db0bd107719c80f3e6c0810a1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "183c1e6f8d35fa28272a425cd495bc72fe5d3b4556662df29ddc9456bc544215"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0e6daf7dd3da6fff4cbd9e5f1398c306e1f54a83de09d8d840870b22919a7642"
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