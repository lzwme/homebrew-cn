class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.4.34",
      revision: "8767835667ebceb7eca30e2654c55ceac2b041e6"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f244aad1dd144f0c26c357b41320153a2486767971c51fca99689d1ec8390f4a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f244aad1dd144f0c26c357b41320153a2486767971c51fca99689d1ec8390f4a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f244aad1dd144f0c26c357b41320153a2486767971c51fca99689d1ec8390f4a"
    sha256 cellar: :any_skip_relocation, sonoma:        "5a7ce78da24a774dd24bb23753c42dea634a3e4aaa15d1efcde112132b788c4c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e758d9853c0900ea3cac014b30c208f8d7cb035891b281dafc67721eec16f5e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "69f6ae81888075b171a4ec19feea9c4addc3fbbf565d0ffa3c6fcda49afd3a85"
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
    assert_match "Error: no access token available. Please login with 'flyctl auth login'\n", flyctl_status

    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON

    assert_match "Create a new Fly.io app", pipe_output("#{bin}/flyctl mcp server", json, 0)
  end
end