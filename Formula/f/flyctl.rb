class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.4.51",
      revision: "c9a702da2dab3d54ee0d5cd81fbc39d4a49c86ed"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8f1b512bf1be1e4ab244ca90991c6d43cc43327208bd068733eb985f112ae476"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8f1b512bf1be1e4ab244ca90991c6d43cc43327208bd068733eb985f112ae476"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8f1b512bf1be1e4ab244ca90991c6d43cc43327208bd068733eb985f112ae476"
    sha256 cellar: :any_skip_relocation, sonoma:        "3294a90e3b91df991499bd0355fda0fa384ca5e4c925a8867ae17963daf7acb3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "189e404117f21701e61726e0bcda34fe861ff04d0b42471c353d6c4e0f2ad169"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b278bc2610c2faf09ccd5d8141a3afda25b9ef1487712cddc66d10e84b658a8c"
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