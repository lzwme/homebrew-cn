class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.3.233",
      revision: "8e47e0d290d351f3e55ac3f5c0ec2ce5e9ed4b16"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "272964bf4bc10fdd43f47c1948cba9e7dbe88a904119116ff1008e1c58557306"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "272964bf4bc10fdd43f47c1948cba9e7dbe88a904119116ff1008e1c58557306"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "272964bf4bc10fdd43f47c1948cba9e7dbe88a904119116ff1008e1c58557306"
    sha256 cellar: :any_skip_relocation, sonoma:        "6056e250b975e37b73169c2710766366119d17b4428ddabf2408a11079da5232"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7ea1a9bb0af80490f85d3a0f34bb0887531b7e722118c2a90a5ca1c10be5f7fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "73a7ccdd9d11a3c5ff38da9bf452fee183932c93371050ef8ea54a1bac27d90e"
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