class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.4.70",
      revision: "d8820baeb762e8e60082134c05f4c65c76533a50"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "572756c5212b06e7f7b6ef3031cf949efc25f856b176a014cb3557e1c75d7be4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "572756c5212b06e7f7b6ef3031cf949efc25f856b176a014cb3557e1c75d7be4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "572756c5212b06e7f7b6ef3031cf949efc25f856b176a014cb3557e1c75d7be4"
    sha256 cellar: :any_skip_relocation, sonoma:        "4ac796950073df71a645b061b9c7f477b66995c1115ba1ea66b9dd81b5660152"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5b9c59de822fb9e7acefc3947fd4ef8cd1c2411fbbcfdfa913e45314b5cecec5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "34d43cea56bed04d839ac8d8f21b9d5cc0977e9ebc60fa23ca079f92d87dd4cc"
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