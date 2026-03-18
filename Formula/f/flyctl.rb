class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.4.23",
      revision: "cf30d078873e7de77b9e0f5700fef9851291fb04"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0930f2e4c0b55c959a497e61b6bcce038cb40c70896ffd3b1b0cab82ced71ff0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0930f2e4c0b55c959a497e61b6bcce038cb40c70896ffd3b1b0cab82ced71ff0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0930f2e4c0b55c959a497e61b6bcce038cb40c70896ffd3b1b0cab82ced71ff0"
    sha256 cellar: :any_skip_relocation, sonoma:        "6dd659767e6152b35662fc305d883293971a6fc3f13be2c1732066f40189cbb5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8ec464126920c69c607e1d2cc1e948c4b8f7c15efe19012ac921d1ff54878443"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cffd9a0bfdcf83b5356a3723ce43d0300e71bd0505308c8a59fc6ddb5a840fd7"
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