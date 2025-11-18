class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.3.218",
      revision: "6a38555319a0ab33478bea44ae20a6fe29665425"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4f0eb2973cacb5e33bff086ca39314557a0bac254281d0adf4a48315753c5331"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4f0eb2973cacb5e33bff086ca39314557a0bac254281d0adf4a48315753c5331"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4f0eb2973cacb5e33bff086ca39314557a0bac254281d0adf4a48315753c5331"
    sha256 cellar: :any_skip_relocation, sonoma:        "eb3bd071f410ea501ef7398d9c3390813d3e86fc4e65aa1e6306300116ec8991"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "44fabf13613ee0189c9bc9951c03ae9884e2e0d304b4f5bf12218c0482d4bfde"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc55aec50c7b1561b6bb5814a9936cada1c123ae2eca53b32af8a09a33babc02"
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