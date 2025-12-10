class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.3.231",
      revision: "f286ff0782f4665ea603692951294979d57e56f8"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "35dc0220e8807eb28661e4a0f77ee458ef355149c2635464403603495920bf69"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "35dc0220e8807eb28661e4a0f77ee458ef355149c2635464403603495920bf69"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "35dc0220e8807eb28661e4a0f77ee458ef355149c2635464403603495920bf69"
    sha256 cellar: :any_skip_relocation, sonoma:        "38f146dabc8d135563422cca55c4985a6925650c7ec42b56f083ee33dd703c31"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7367b47b5f8c2ee9f0c7c5428439134ca9f62f276d0f923929eeb19647900b7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7c062a9758f6b8e34d864e60b4f9bcb8648a6d29baebeb8a42f4a6fc88ad6f84"
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