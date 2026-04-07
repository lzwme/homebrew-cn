class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.4.30",
      revision: "e436c72867129bea1fc1c48f61ea6245975403a2"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "05117ca2dba0b95b73ebce1639d81b099453b307d2ca6d4919dac8da0cd46480"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "05117ca2dba0b95b73ebce1639d81b099453b307d2ca6d4919dac8da0cd46480"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "05117ca2dba0b95b73ebce1639d81b099453b307d2ca6d4919dac8da0cd46480"
    sha256 cellar: :any_skip_relocation, sonoma:        "072f820eb62f6f179171cb5de2b24e43670649e5757cd3ec2a877253049babfe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3f759960595662f457e132696773f9d51e88e148bb228c1abb277a1b2fbadc9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3d5d5b5f646d4f5c59b1e7b645fe6439497abe1512311663cfc974d53192c390"
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