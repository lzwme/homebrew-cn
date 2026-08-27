class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.4.94",
      revision: "1f906765dee8e973f6d1dd8fff65b58212e7b425"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4b73de321f9effc826be3b24cb14b5ff1b93807b91200aa936c5b65c91732cee"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4b73de321f9effc826be3b24cb14b5ff1b93807b91200aa936c5b65c91732cee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4b73de321f9effc826be3b24cb14b5ff1b93807b91200aa936c5b65c91732cee"
    sha256 cellar: :any_skip_relocation, sonoma:        "cf13aa46c454f160d0c741883ba9a53b086af10ec841d72952e8862e0230b750"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "33bf6db68d3e6926c1b1aefdbb65d48ec9913b52e21d4c2ce08bcf6492d97451"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7fba3514c0c2b2d9b351d7126624017962af8b42259fe3e7ac564ac32895728c"
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