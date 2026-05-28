class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.4.57",
      revision: "f64e8dc50b4a8065142c8071f67798382604884b"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "10d5594dcb205e35b511314b9e2b556f8bc4f1c06c54380811382d5c163ef226"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "10d5594dcb205e35b511314b9e2b556f8bc4f1c06c54380811382d5c163ef226"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "10d5594dcb205e35b511314b9e2b556f8bc4f1c06c54380811382d5c163ef226"
    sha256 cellar: :any_skip_relocation, sonoma:        "59f0a3fc5eb9a19b7674f13e8d76534bbd7442647e04b7d74c7a1073047e9076"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "95ef0d1ef9929fa6853c53da08d8c501db1e0eec9a7bacd613e76547d8ba064f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7caeb73d09388af21b8223fa1ed3bc8cf2790468961ae676570f616c1a5f564c"
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