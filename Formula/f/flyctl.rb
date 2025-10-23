class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.3.201",
      revision: "2b8da2f14817ccd05690e3246101528b0fddb82d"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "79270ff44276919961c859aefdbce94d580ab84abec4162a503a664ddaf7bc20"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "79270ff44276919961c859aefdbce94d580ab84abec4162a503a664ddaf7bc20"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "79270ff44276919961c859aefdbce94d580ab84abec4162a503a664ddaf7bc20"
    sha256 cellar: :any_skip_relocation, sonoma:        "3d62b557683edb819bbf3a207bb60b209bde00aa5a6846633ba94577673361b5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d84afaf544a64a7da3da7a48d88ba88690ec86a60380089c55c8161517176520"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c40b3a96f01557cda4a1cd2d050808a6e87f86a5425c1308b9ed139e486ac0fb"
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

    generate_completions_from_executable(bin/"flyctl", "completion")
    generate_completions_from_executable(bin/"fly", "completion")
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