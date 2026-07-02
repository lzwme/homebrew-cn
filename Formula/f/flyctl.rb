class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.4.64",
      revision: "7131b8114adedbf6ba3174061f44bb3ce0f5c7d6"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b2f6cb585eb7c2dbd80aa6b909a181285abeb2f9c4db5710401457b91d74a4db"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b2f6cb585eb7c2dbd80aa6b909a181285abeb2f9c4db5710401457b91d74a4db"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b2f6cb585eb7c2dbd80aa6b909a181285abeb2f9c4db5710401457b91d74a4db"
    sha256 cellar: :any_skip_relocation, sonoma:        "d9b7b303e507cca87bcb6c590e0dcd1b8e4059905baa5fd7fb51b5fda0ca74de"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7493a0be4868eeb6e6a8ac894d597c0a3d9f34a251c6e384e374384f251b45a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6ac7876dd10866c1e304ae8622b032346f021873341c1a4791d49fc2b96884ec"
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