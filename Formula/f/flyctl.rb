class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.4.1",
      revision: "7e342cd5ef931c5d037a33924de85f66839958ef"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "935599107ccd5ece52fab36dd934b04567d330674ac3f43486c41ab408e6d8a6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "935599107ccd5ece52fab36dd934b04567d330674ac3f43486c41ab408e6d8a6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "935599107ccd5ece52fab36dd934b04567d330674ac3f43486c41ab408e6d8a6"
    sha256 cellar: :any_skip_relocation, sonoma:        "4ff2e33bba0f9537471357890a08d1fca2887821ed842f277e75d9e4294cd7ec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "de052388cb73282a8531649a43c58209e050573a36ecc00172ab69e04d673200"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "33987f88423f81834e7f4557ea1d85d667230e5cc39b6cc3aa61e2d9e413f332"
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