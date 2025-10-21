class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.3.198",
      revision: "83bfe8378b2d087dee4b41f33d7a7f8680944480"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b8bd7227800fad1d6a6d3792d9ce548e80fbc5837438ce2a12e90d961d7f1d16"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b8bd7227800fad1d6a6d3792d9ce548e80fbc5837438ce2a12e90d961d7f1d16"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b8bd7227800fad1d6a6d3792d9ce548e80fbc5837438ce2a12e90d961d7f1d16"
    sha256 cellar: :any_skip_relocation, sonoma:        "efb5f28fffe9eaff43e2780ae67cf58a059a9ea23a523154f08df5ec597bc3ad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "66628ccc428453eb8147df02198f412e71125c4f8df4ff447e091dfb550d2e54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2adb840c2b512a045e2f36c26a61bc087f03e800ef826f1024caa2ec8c124b7a"
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