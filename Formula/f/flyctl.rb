class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.4.44",
      revision: "f496da16077db099fd8e8a97fd8e8d32a394f695"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b1e166f3a7f4e24e3533f6fe98ebd9f6903e3ad57cd57dcfc101ffa7f5f5e98e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b1e166f3a7f4e24e3533f6fe98ebd9f6903e3ad57cd57dcfc101ffa7f5f5e98e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b1e166f3a7f4e24e3533f6fe98ebd9f6903e3ad57cd57dcfc101ffa7f5f5e98e"
    sha256 cellar: :any_skip_relocation, sonoma:        "6b4e66c35923d2dfe79fa998d6b3e8fae42521dd800f309eb483920b18e41859"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "25163173e47f53b0d24591e25c0008e74a08b7b1ec5a4bbeffad1d29cfb2b865"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3eea458cd9619cdb575ba0f2b92adf526194b84292dc302bdc74a03c8a1799a5"
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