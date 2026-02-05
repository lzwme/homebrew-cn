class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.4.7",
      revision: "b9d5d507969f3e2e6e66ae43aba7ba4bd69bfd72"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fac7533537a64ff8ea94c579204e4a74111a1419ddde8bc1d918cb80fcc4fce9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fac7533537a64ff8ea94c579204e4a74111a1419ddde8bc1d918cb80fcc4fce9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fac7533537a64ff8ea94c579204e4a74111a1419ddde8bc1d918cb80fcc4fce9"
    sha256 cellar: :any_skip_relocation, sonoma:        "65902ea257afa1ab1d2b116a5daa4c5ce64978a3c4e7ee0dbcd0b6408a5bfc08"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "64ee49e749291f581a87074f682745dc69630bda691944ce4c11dd15fd314909"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1a37cf46008727127530a3acc6958d71219fb924d19739ff342e66b8c31440c2"
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
    assert_match "Error: No access token available. Please login with 'flyctl auth login'", flyctl_status

    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON

    assert_match "Create a new Fly.io app", pipe_output("#{bin}/flyctl mcp server", json, 0)
  end
end