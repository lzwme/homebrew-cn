class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.3.211",
      revision: "778a18f970f1d676779658a957b3525840497a0f"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2d899daa6591d587a7661b8a299f6420bf837b80c53a1599e85380af054125bc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2d899daa6591d587a7661b8a299f6420bf837b80c53a1599e85380af054125bc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2d899daa6591d587a7661b8a299f6420bf837b80c53a1599e85380af054125bc"
    sha256 cellar: :any_skip_relocation, sonoma:        "b20c46537cb7b7b898031eae79e3b89d566b3b230da598cecbd89112e4c4aaa9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1c4c7b7396397bf28cb821ef5918a9aa86fea06687d506cd7fe54b4151944b2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e947a7cb116ad3d8f149d847eeda5ca75aae857f40132e77a0ca8a8f35c54c17"
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