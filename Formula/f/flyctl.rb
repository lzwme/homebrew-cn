class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.4.27",
      revision: "1587d18a19d43934dd0ed12b1206b5b869bdc297"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3f708a0c4463d1e42c13453a65bf3a7593ccf29f460caee83cb8bfe2167e4cdb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3f708a0c4463d1e42c13453a65bf3a7593ccf29f460caee83cb8bfe2167e4cdb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3f708a0c4463d1e42c13453a65bf3a7593ccf29f460caee83cb8bfe2167e4cdb"
    sha256 cellar: :any_skip_relocation, sonoma:        "016cbfd0fa428f1af28af7caf3a3f05fdb0e5e623f22e7c6b1d84061ac90c2b7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1d7275e8c0f660c89dcad44cec1c0d835176f7d2402fa311fdcf59d4b6d6b802"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fb429e5114e89cd8341fc5ab34979d7409e0f393cef940159f38b7c2270ede9e"
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