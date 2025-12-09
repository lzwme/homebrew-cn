class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.3.230",
      revision: "bdbb230421b0e6e696560f30fd8525ca3ad12ea2"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ddcd4fec433177f41283acbfe60bfe8fadcb20c937c6ff7e7d8f24f35cff33ae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ddcd4fec433177f41283acbfe60bfe8fadcb20c937c6ff7e7d8f24f35cff33ae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ddcd4fec433177f41283acbfe60bfe8fadcb20c937c6ff7e7d8f24f35cff33ae"
    sha256 cellar: :any_skip_relocation, sonoma:        "9cbf36b8f49e751c11201986fa345ada4a441c47e1fba4ada27545b3b5ce9ba5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "809f237eec4a89e1707eef433e0c283bfa8b61ac813e0c920ef7cc2ab9a73e54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d46fb6472d7ff93c3210b3f9ca0031834680efe64b004e887a8f4c6ca68a4f6"
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