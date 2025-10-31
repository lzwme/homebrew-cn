class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.3.206",
      revision: "f40ad4c3e63b5f7d33f51217c48995d78796e3d1"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3e7540ce015b37f3e174db5e0ba3c9c9144141f73f80454392d309c4a56ec2d8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3e7540ce015b37f3e174db5e0ba3c9c9144141f73f80454392d309c4a56ec2d8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3e7540ce015b37f3e174db5e0ba3c9c9144141f73f80454392d309c4a56ec2d8"
    sha256 cellar: :any_skip_relocation, sonoma:        "ca04a4173555579ee2bd8aa9c82a6234d9a812086f4102853d7bc2edeb1277ba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "326a13420a183bac21fc0e90780c9a239b629d66f4ca7d662ad61dc30e37d029"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a152f0f8e6cee59bdb416fc1f37eda1fda4363dbe1d6475c7e3c9e68e2077cd2"
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