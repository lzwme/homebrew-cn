class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.4.75",
      revision: "829dd22fe528dd733754ff98fc178defc440e187"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "12b65beedd7de012bbb02884fc2beb175c42c7f2a01773948dcdf5023e4007b9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "12b65beedd7de012bbb02884fc2beb175c42c7f2a01773948dcdf5023e4007b9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "12b65beedd7de012bbb02884fc2beb175c42c7f2a01773948dcdf5023e4007b9"
    sha256 cellar: :any_skip_relocation, sonoma:        "016625b1e97e4e8bb27e939b794e2cd181422addfb2f2304c3f32ef3f561adf8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b967fc5bffe8f73e8d08fd7be714ca4fb9ebb05a76d55fcb0e05d6c478eaf4a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "46a89d5308a994cca17136f7cb226d3486978913a21169980b85ac87602e8cad"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
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