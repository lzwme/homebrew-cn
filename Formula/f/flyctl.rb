class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.4.59",
      revision: "d10482182142f259db338dcef34556a67702290c"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8b10adef80c49736e9ffd39097e255f3081fb01dd27ee6c0e9d8477b2a34d474"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8b10adef80c49736e9ffd39097e255f3081fb01dd27ee6c0e9d8477b2a34d474"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8b10adef80c49736e9ffd39097e255f3081fb01dd27ee6c0e9d8477b2a34d474"
    sha256 cellar: :any_skip_relocation, sonoma:        "0e5ab4962d1bf62f629ced3da4b6f6e7cea96fc3b2c326d2ebfe8d755a1541b0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d549708f690ca34829152fac0f613c29a12c8a4a3497935fd2b8a7dfd1543845"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "310ca5984c33604532a26482d8aca9904f1d6e037a3f69df051d0e22f0414850"
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