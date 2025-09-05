class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.3.175",
      revision: "a377ba2df40a8b71e54bd1fcecbc14252ca75a2b"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "18edf5532e6c9a25dcae89b30d6de5db52f221088bbb85b3047bfc20f707d104"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "18edf5532e6c9a25dcae89b30d6de5db52f221088bbb85b3047bfc20f707d104"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "18edf5532e6c9a25dcae89b30d6de5db52f221088bbb85b3047bfc20f707d104"
    sha256 cellar: :any_skip_relocation, sonoma:        "5b6c8c80748b5049d40930c7093d9f17e6886ab6b3f383e157b0b577d6ad5c81"
    sha256 cellar: :any_skip_relocation, ventura:       "5b6c8c80748b5049d40930c7093d9f17e6886ab6b3f383e157b0b577d6ad5c81"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b84ad9236f43cb223b70ecca9b54715cdbf225a392d38365bab3d7bc24338d1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "298e5a305816691706149ffbd96d58d72cdd58accc846633ccf8e90f4d0558b4"
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