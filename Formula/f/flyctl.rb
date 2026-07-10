class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.4.69",
      revision: "324951dd0286e1ff34dbceeb54ef8c4dc09c1668"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1dfe67d8186b26a70e2d9322aef2d4df15d8042dd8ef735754ce6c247d643a28"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1dfe67d8186b26a70e2d9322aef2d4df15d8042dd8ef735754ce6c247d643a28"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1dfe67d8186b26a70e2d9322aef2d4df15d8042dd8ef735754ce6c247d643a28"
    sha256 cellar: :any_skip_relocation, sonoma:        "e083d417320dfae3d43404a4a029c72c96b342411d9175a679aeee6556af04f6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fecd5f72485d081a2c4d528ee5591d5504b0c5ae542afa243b7511b32dd49918"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd0f9012546de24dc09667707340bec1f9259e6c489c8103931116e9ff2a3375"
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