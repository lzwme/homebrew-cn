class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.3.219",
      revision: "1d97feff90f738d88a57a04b7bd71bd9ee8ac18b"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0104b004f8e2e942ec1eac15f6fcc5a142122988aedc9f3e157b286e630d60f9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0104b004f8e2e942ec1eac15f6fcc5a142122988aedc9f3e157b286e630d60f9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0104b004f8e2e942ec1eac15f6fcc5a142122988aedc9f3e157b286e630d60f9"
    sha256 cellar: :any_skip_relocation, sonoma:        "c98f9fdc0eadf039fc9e3403dd0906cac4d7d806a62a72aa37b4a81c9561d25a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "83eea98e9e487578438b83ba33210e9f4b4c69366f9f422e51c0d429c33518a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec6ff1af37d7fbface3907a1e5230dfbc702918fc6f4a46bbb351b4127273592"
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