class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.3.202",
      revision: "d170dd15b783eafe37a895494716d0414c4ed4c2"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ca9d8a0cf745c3ebd4f9900c33fa1974db513b722b28d73e48b611862ad6cc09"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ca9d8a0cf745c3ebd4f9900c33fa1974db513b722b28d73e48b611862ad6cc09"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ca9d8a0cf745c3ebd4f9900c33fa1974db513b722b28d73e48b611862ad6cc09"
    sha256 cellar: :any_skip_relocation, sonoma:        "02260d7b479468daf2d41a264005bf634ffae3fe9c5d84679434f2755cdaa268"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5630138d0fd80aea28be2de2ef4491ac783b726624e351eabc2e3eb0ff1c6ce2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bce2e1edc0e8e4abdb2deed7660ff4e86eac8d8b48885e8be82bde96902b7e36"
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