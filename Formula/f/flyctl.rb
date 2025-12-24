class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.3.236",
      revision: "33800f89d9a359a3ed32dd918aefb17bea30ad7a"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2aea9dccac3fc1869572d2b2d602ed385b1e229dc9c4899ca5b07728f8e96616"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2aea9dccac3fc1869572d2b2d602ed385b1e229dc9c4899ca5b07728f8e96616"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2aea9dccac3fc1869572d2b2d602ed385b1e229dc9c4899ca5b07728f8e96616"
    sha256 cellar: :any_skip_relocation, sonoma:        "b9637d714c55fc4d4e92ec8b06c865dad5936c932464a2d92ba8b35bf5838ad4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "60514c0279c7d5fd43d69210fbea8f8b5edb62c4e5ce6a960614396dfbe3db80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d7fc4bfb2f0826446df6592e9970b903770b3ce0aa8de8fbf68ecb7f60ce1dc6"
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