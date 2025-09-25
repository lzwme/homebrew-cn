class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.3.185",
      revision: "aa24366bed72757cb4e395dc47551d957ac58eec"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "041973a6e6a6b274a3fe426b3a6a9a9cd03721c8fee0e2981b0015669dc83cea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "041973a6e6a6b274a3fe426b3a6a9a9cd03721c8fee0e2981b0015669dc83cea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "041973a6e6a6b274a3fe426b3a6a9a9cd03721c8fee0e2981b0015669dc83cea"
    sha256 cellar: :any_skip_relocation, sonoma:        "2ca69aeb39ca432a789856230db181333c65a78860eba895392c8f3b20a5d7a6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ebb80faf508296fb1803dc780e2324913b0067ea3a05d224e4c6dbe1de5d3bb9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "185d9a1b9db825ed444c6a1434a917d8a7645ec62b140dd4d86b4c76b94d09d7"
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