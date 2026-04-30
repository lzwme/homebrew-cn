class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.4.43",
      revision: "1607bfaf44909a0f9029313ec44f3054ecc43e54"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c4faf986c8c985a12cbabff19aa9e5220c45c49d4531dac933ca2f5d850fe15b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c4faf986c8c985a12cbabff19aa9e5220c45c49d4531dac933ca2f5d850fe15b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c4faf986c8c985a12cbabff19aa9e5220c45c49d4531dac933ca2f5d850fe15b"
    sha256 cellar: :any_skip_relocation, sonoma:        "47b2a87e284d1176eeeac9ce8b44027477aed27353f1e5deb26d7ea7313af756"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c8e52753d336d95ae200e7796cd95e1bfed9f603ac322a39b94f125e5e4c9ae5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ff7322e75d9eb06afdfb4fa0df1277d8441d5dced893e4c52a2167d95aaff1d"
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