class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.4.65",
      revision: "bf9446f0e202ed36e8aa8ebf1292b51cb6ed3d8e"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "801f68be750c72257ab87685c2319ab1cdc80d762793c12e5039dc27f7700e0f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "801f68be750c72257ab87685c2319ab1cdc80d762793c12e5039dc27f7700e0f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "801f68be750c72257ab87685c2319ab1cdc80d762793c12e5039dc27f7700e0f"
    sha256 cellar: :any_skip_relocation, sonoma:        "818c8b4d2830fad43aba1ed742dc0a6a7ddeb56fda9fecdaff07d4553a71dcc1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f42cb95216d077eaa28702bf5d2a06708947326d80b745bca7127beea0960325"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "30899735e34b7cd6f37e31e6d7d574572e85a34cb1bc03552979e162b58232df"
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