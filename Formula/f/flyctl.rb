class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.3.203",
      revision: "5f5f50ee82cbdfa7cbabe38161c1acae50f832d3"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b4dc578fe8f3dcf653c360922c795528804c70dca8f8418614c2acbae6516a90"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b4dc578fe8f3dcf653c360922c795528804c70dca8f8418614c2acbae6516a90"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b4dc578fe8f3dcf653c360922c795528804c70dca8f8418614c2acbae6516a90"
    sha256 cellar: :any_skip_relocation, sonoma:        "2802adeb7de5c973b8bee9d41017b70d8f56e0b65012b3a0eee5630dc03de9e9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3f7ad93b7bafa7095e56d695769d2d01c9f3acff8340d4a4339a94aa7bbecf8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1016166a6132388182104bc1689712bb2a9a5672569fb21d634a092ae3277c5c"
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