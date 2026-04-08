class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.4.31",
      revision: "26f5dd02de9dbef1deb0baffc7da5daa72fea155"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e0fbbc2e53493c667f9293c0b2b5beab8316afc2e833a2ecbd5fb3cd906a5696"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e0fbbc2e53493c667f9293c0b2b5beab8316afc2e833a2ecbd5fb3cd906a5696"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e0fbbc2e53493c667f9293c0b2b5beab8316afc2e833a2ecbd5fb3cd906a5696"
    sha256 cellar: :any_skip_relocation, sonoma:        "977ecd84ffd9507e29594c7fca3fb701a5bac62d7fe26bb4454a58b0a9893299"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f8a0092f42456bec66d8ef77133f9fc4623436d004838162984d85b78f7cdf58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a72a133380b677b05f21513499aa5f8a1e18dc08c4bdd3e2d51e567636a889fd"
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