class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.4.48",
      revision: "122597548e66f2603fd7cdd4933f0b6fe26c96c2"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b9b2d4920800bc621d98d650c7e3a7b463a89f967e0778087d288170e3421342"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b9b2d4920800bc621d98d650c7e3a7b463a89f967e0778087d288170e3421342"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b9b2d4920800bc621d98d650c7e3a7b463a89f967e0778087d288170e3421342"
    sha256 cellar: :any_skip_relocation, sonoma:        "a718d57c05cd2d730160a8d0aa148287b16406f96224a88ba7f91d8f2cb6cc0c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bc23b8900216429553223b398c03ea32c96cc7aac430f85a424413c4291d60b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "729d17df8fb6dce37e83fba5425c57863683a0c329ba047538617c3bd2c9ef87"
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