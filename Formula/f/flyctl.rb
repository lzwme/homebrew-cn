class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.3.220",
      revision: "dc05102e722132dbbc94449eaf2158a3180afaba"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dbb7e07b6c8f153a3da4f9a9f8dfa2e7d0047d1c2c4c22eff99f6fcdeaa532ed"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dbb7e07b6c8f153a3da4f9a9f8dfa2e7d0047d1c2c4c22eff99f6fcdeaa532ed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dbb7e07b6c8f153a3da4f9a9f8dfa2e7d0047d1c2c4c22eff99f6fcdeaa532ed"
    sha256 cellar: :any_skip_relocation, sonoma:        "ca3862a3e40406a3804bccda50d8c9307e3cd734be91897d71207306d6f7dc4d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4bff3cd654097fb9cf8af4514b3a2d5d81cb26c35ca7a38afc8259794187026b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0a6cc854745bd4ffd6f2c4d23a86f7a467c7750aaa2fbd238161547170bd5a19"
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