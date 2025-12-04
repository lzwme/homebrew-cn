class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.3.228",
      revision: "e330d0a298682eaef7c269143261bfd5f5150ff8"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "80d06f3ef1a3e77ff8da54ef533ad325dda247443a3c8d4f833ed115cb13ea20"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "80d06f3ef1a3e77ff8da54ef533ad325dda247443a3c8d4f833ed115cb13ea20"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "80d06f3ef1a3e77ff8da54ef533ad325dda247443a3c8d4f833ed115cb13ea20"
    sha256 cellar: :any_skip_relocation, sonoma:        "5693705a6722ed351595ebf7fe158adaa2c5d622525b0e43e15b1385e8cab646"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9ea794bf9984c2f817b51c93e7a211bebbe3d95edaa23e42ae6a1ead15ce9d11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dcf0b7d94d89b621a5d14dcf7db4ec3a4201ec9e84c158ace6aeac5ad28a28d8"
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