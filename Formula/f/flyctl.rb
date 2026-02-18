class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.4.13",
      revision: "33409baa720be83405bbd09f39131ff376f96b02"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "506d178b83e86fdf7c9d2abffb79ee804a8c62b32165da3ae06413e673851d28"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "506d178b83e86fdf7c9d2abffb79ee804a8c62b32165da3ae06413e673851d28"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "506d178b83e86fdf7c9d2abffb79ee804a8c62b32165da3ae06413e673851d28"
    sha256 cellar: :any_skip_relocation, sonoma:        "4d3a9a93f6297be069aadbdfe2ddb415c5afefab5d41669fa2e3c1e8991030a9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5297030c27c34215fb2d4b45b290a110c64c582d8081092be3e227b25a12b1cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "feac2ce0fd988903bd677a6701e10e81a585988fa6b03b36368850771c25a6dd"
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
    assert_match "Error: No access token available. Please login with 'flyctl auth login'", flyctl_status

    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON

    assert_match "Create a new Fly.io app", pipe_output("#{bin}/flyctl mcp server", json, 0)
  end
end