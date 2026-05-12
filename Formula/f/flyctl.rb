class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.4.50",
      revision: "78f36b7c623585855d0c43b75abf3eb62dab2e34"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "06fd2831fc9e92fd4f23d33c04b15e5f43cb8fc87c84244c117bbe20a566c28a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "06fd2831fc9e92fd4f23d33c04b15e5f43cb8fc87c84244c117bbe20a566c28a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "06fd2831fc9e92fd4f23d33c04b15e5f43cb8fc87c84244c117bbe20a566c28a"
    sha256 cellar: :any_skip_relocation, sonoma:        "b990831dd95c9626399f670a28baa6a7cec66ea2c326758716430ca8c19dee9b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "99de3ae3426f25dce6b5102b377c6116f8af1b4e429274b7ee83ff418a532c01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "826843fc1babeff4c62683fe34468bec181a5596368ac0a620e52380f40b2faf"
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