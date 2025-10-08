class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.3.193",
      revision: "231a86b8a4f9fa7d5a03dd8b3001ebd79f873bc0"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6c1c50f394495ec9341414269c0b37bd71c6bf640f7baf04eaac9a472494eae8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6c1c50f394495ec9341414269c0b37bd71c6bf640f7baf04eaac9a472494eae8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6c1c50f394495ec9341414269c0b37bd71c6bf640f7baf04eaac9a472494eae8"
    sha256 cellar: :any_skip_relocation, sonoma:        "9e5dafa73f346cb7789f8bef11f9268c20b3a6b4aadb531c99e012599a7cc1fb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "45b0bbd374b770355c31f9507d417affb5f613cab6f892c2d7b570b93173f3df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b56fa22263edb32649726cf0fbf51c8e00a4cf82ca3654c1eec2353a6cd0a57b"
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