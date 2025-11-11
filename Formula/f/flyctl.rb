class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.3.210",
      revision: "5a396deda7cb1b0e2a45ee5b1d802e4638920652"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3483203847b95be4beaba36866881b229616933b530f7badc8e7df009845afe1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3483203847b95be4beaba36866881b229616933b530f7badc8e7df009845afe1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3483203847b95be4beaba36866881b229616933b530f7badc8e7df009845afe1"
    sha256 cellar: :any_skip_relocation, sonoma:        "d35923fb291e98095c115bd81d88ab0e46cbcaf51c1675ebfe2645ac4ae66290"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1be661679e118bf6d59e1c8ed7edfc20d740ce6dd569e828e0062065d6b81321"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e7a71798c5bfc604956fb6a9d191ac2bda2c6b1c789a2ad28e1c227dd817465"
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