class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.3.184",
      revision: "a44a39300c037994baf65746d91c26c145eea40a"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6f8ae14b2823923b713ba09b65a9da24883a8e4527147a566058a37a68ad9ad9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6f8ae14b2823923b713ba09b65a9da24883a8e4527147a566058a37a68ad9ad9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6f8ae14b2823923b713ba09b65a9da24883a8e4527147a566058a37a68ad9ad9"
    sha256 cellar: :any_skip_relocation, sonoma:        "4051214db06ff36ff2ee0585d226d2f94032123a14a1ef8576475a4cf66188b7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a4fedc52448dbd6c46c8c71bef81aaef80fe2f63eeecd129f5a3c2b5d99a7825"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "16f2bf9380d919257d0340553bddcf0591aa7c8bb5f87967d754ae151ed0307f"
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