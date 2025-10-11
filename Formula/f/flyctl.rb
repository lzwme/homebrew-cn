class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.3.194",
      revision: "349e744703296b031cb30f9a4664ad8ffc60f7c3"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cf6018392e9a4e2fab27adfcf54454bb8adc4021e1652c5c2c248be22ca335e4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cf6018392e9a4e2fab27adfcf54454bb8adc4021e1652c5c2c248be22ca335e4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cf6018392e9a4e2fab27adfcf54454bb8adc4021e1652c5c2c248be22ca335e4"
    sha256 cellar: :any_skip_relocation, sonoma:        "407b236b8aad4a110dd2ce762133700e37a404a82059d2b510d441f79f09a4e1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "628d9eb6666ea7aa26ef6f89e1353ab14b201fb8723894b45c28d1031e306691"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "499db6f54250f1f8132674bcaa4d01c2fd3d41aea245e92dc3aba8398274794a"
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