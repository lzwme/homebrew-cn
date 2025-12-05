class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.3.229",
      revision: "6bcf8763ce0da157c273ecbe0e86252e96ca16fb"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f6a08525e0f2a0534e515e6591cdcbf0842b42e998d153b663aa00ebbfe03a07"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f6a08525e0f2a0534e515e6591cdcbf0842b42e998d153b663aa00ebbfe03a07"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f6a08525e0f2a0534e515e6591cdcbf0842b42e998d153b663aa00ebbfe03a07"
    sha256 cellar: :any_skip_relocation, sonoma:        "9a353e520b0be9176865e640085863b9c3f4360ed6a3eefacef5d2a80dbe18d3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d521db323ee75c5d09d1cb30e5be686e103ed7c1ef5f00f0a134d39852d167d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cc35ccc1d08bf92170d0a3592dea40e0c2a813125b330a9607f62890e1416c18"
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