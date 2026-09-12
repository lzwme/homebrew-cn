class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.4.102",
      revision: "45ebe187e223362d4ac1cc91caa82e0d75385c51"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b8b70b40e3682210310b50d5a72626e944c0b4cd938635e83b52e27829c90962"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b8b70b40e3682210310b50d5a72626e944c0b4cd938635e83b52e27829c90962"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b8b70b40e3682210310b50d5a72626e944c0b4cd938635e83b52e27829c90962"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "b8b70b40e3682210310b50d5a72626e944c0b4cd938635e83b52e27829c90962"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "aa5e93a7e0b609a5f05f4546e7945b9670538fc7b008cdc6b016901841f62fcd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "357072cd86cfebd5940ed332c96851f5f4413fd28ad9e0235287141937b99213"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
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