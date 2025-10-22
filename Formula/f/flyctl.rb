class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.3.199",
      revision: "9afca05fb1d87bf194624c2dcf5d68d0df728d44"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f83124dc0e6c7afa3f4ccceea1bac380a727ba73934acde8de1cf3297b38f495"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f83124dc0e6c7afa3f4ccceea1bac380a727ba73934acde8de1cf3297b38f495"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f83124dc0e6c7afa3f4ccceea1bac380a727ba73934acde8de1cf3297b38f495"
    sha256 cellar: :any_skip_relocation, sonoma:        "d798223a5bd8befbc59db6563d5c13688d4d64a3f90d548cef2ee16b28a95ec9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b564e7212225bc030c8c7d0d1274dfee5e7ccdf0524ef0b67917bc64ab940661"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "076a9942fd67afd44f1681860a69a0fdb31c138d95c67535c582316135b51143"
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

    generate_completions_from_executable(bin/"flyctl", "completion")
    generate_completions_from_executable(bin/"fly", "completion")
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