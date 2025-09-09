class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.3.176",
      revision: "7a4f141d41455520ce2accdf4e8f990618fa72a1"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e736b5b8dc0547098fc827d8b92a78f2c4b4fbbb1c0971faeb110eeca7bb2112"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e736b5b8dc0547098fc827d8b92a78f2c4b4fbbb1c0971faeb110eeca7bb2112"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e736b5b8dc0547098fc827d8b92a78f2c4b4fbbb1c0971faeb110eeca7bb2112"
    sha256 cellar: :any_skip_relocation, sonoma:        "84c18960252972cc44c74befafcdc14c0a9a6a22343d51b88679225110c2cbf6"
    sha256 cellar: :any_skip_relocation, ventura:       "84c18960252972cc44c74befafcdc14c0a9a6a22343d51b88679225110c2cbf6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "51c559166c2df03ea582b5ad62d76f0c381a84d5ac831428aa8636944494f43b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8bc66e3a745ad54db23b655cc774e3ed7f0478f02e1fb69b39f3923316c1539c"
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