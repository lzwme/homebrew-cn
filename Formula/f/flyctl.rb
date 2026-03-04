class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.4.17",
      revision: "a614657e5e87f33f4e0fb6e96992b3560a0a2ec9"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4a2be4eed4900a9c8298661a0add0b47be532b422e9d8c7d6c4660f7fce79faa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4a2be4eed4900a9c8298661a0add0b47be532b422e9d8c7d6c4660f7fce79faa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4a2be4eed4900a9c8298661a0add0b47be532b422e9d8c7d6c4660f7fce79faa"
    sha256 cellar: :any_skip_relocation, sonoma:        "a39eb044c06387e810eaa5e1117a91ff1bb0af8d8f2612c406ded8b7e0ecaefe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7ed38d3792f4b07985b5a4a19d8327514371d08c19b2e84cff0daa54ee49e8a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aebbeb9fed63d2c4eb1b5cc8414dc426beb4b0e394719dc9d8d0377e27dd0dc0"
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