class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.4.15",
      revision: "c4e6d8d4dd7c046b1e5bc5f57881502d22a2b940"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cccfe2677400e59f975e3536fca042dc771d6e5342af98f15a1612eb7236e6ee"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cccfe2677400e59f975e3536fca042dc771d6e5342af98f15a1612eb7236e6ee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cccfe2677400e59f975e3536fca042dc771d6e5342af98f15a1612eb7236e6ee"
    sha256 cellar: :any_skip_relocation, sonoma:        "85bc7767a53d438b3d3a9762b6360d6d9ea2a7cb2e1ad74cfebd914eb33c014c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c5e5724fd4df16abe9aeee95fdf7a972f5ace3f063ea9e68440ab0c5741b0d33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d3178200ad7e3b78f5a999ad4f5c14b08693fd6154b670fefea5aa5a8ee73a6c"
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