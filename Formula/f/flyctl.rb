class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.4.88",
      revision: "1c8d8f83fef9f054028d54cdf5520d3f93f1c24b"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7faf6744d0939e2134f5b7859f880dc431f7f999ca26435436c901063a1ac295"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7faf6744d0939e2134f5b7859f880dc431f7f999ca26435436c901063a1ac295"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7faf6744d0939e2134f5b7859f880dc431f7f999ca26435436c901063a1ac295"
    sha256 cellar: :any_skip_relocation, sonoma:        "2805ea259d2ed2ed72df347ad136d2890091c99534dd2361799d83d3a6e5386f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "244d0fbf050754d39d9e996c7e8a58ed3a06338d00116a73c3a071ab71ceb54b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "39aeab9ba5d5950664040718687cf17c35aa7808e7238607bef9fbca43a85635"
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