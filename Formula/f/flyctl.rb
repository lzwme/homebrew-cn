class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.4.66",
      revision: "47db924842bbb8b46952ffb2d2abf4b8844c30fa"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5265d13ca16febbde938c4239695a1e3fc281441c24aa9dc676eb8c4c43c068e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5265d13ca16febbde938c4239695a1e3fc281441c24aa9dc676eb8c4c43c068e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5265d13ca16febbde938c4239695a1e3fc281441c24aa9dc676eb8c4c43c068e"
    sha256 cellar: :any_skip_relocation, sonoma:        "e43e288e031471610e23a9b5a16da1cc22495657e0ec03f78c97d45d50c050eb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7e26aa3a9e9afa61b9e1f3e4e73ba6cf0b08baad57444b016e176479bd0d4a8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d85f57bad48b602ae45e7cf5311ce49cec705cacd0ad507486f163e46b762088"
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