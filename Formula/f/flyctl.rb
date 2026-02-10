class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.4.8",
      revision: "f4ae2e34afc942719858fb91f9d64d257da63a67"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cb48b6fb8501c1f73414f941c7ac26e629108a519cf4a00194c227f0852a080e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cb48b6fb8501c1f73414f941c7ac26e629108a519cf4a00194c227f0852a080e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cb48b6fb8501c1f73414f941c7ac26e629108a519cf4a00194c227f0852a080e"
    sha256 cellar: :any_skip_relocation, sonoma:        "7dd0fac4139713d480ff0daa83aea78015769dd8663befce5f4569ff088d46ac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "59aedec2e9c14b2d7ab4b75e8b500b6da0ada73b7436bcbbc0f2dff62f916d9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4223e1adfad80f57c0a0cc276aff763f92aa9cfe4b791de9348d95972a6644d5"
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