class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.4.80",
      revision: "180de61a617a9ee9936045c2b40e0d2f6461d70b"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "be1d317c86e23c66a084d42ffc24fd583d7717cf46db4a522392bd6a1cb7f982"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "be1d317c86e23c66a084d42ffc24fd583d7717cf46db4a522392bd6a1cb7f982"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "be1d317c86e23c66a084d42ffc24fd583d7717cf46db4a522392bd6a1cb7f982"
    sha256 cellar: :any_skip_relocation, sonoma:        "3e0aec398eb84bebf1298f4bad53c54e269e11f33495c39255a62ad17ad15dc7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2bd9e1fd2241bf2b7e6c745b79413caa6d46b7aa68a45131f4c9a820fa60ad36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ade3f0bd5938f7ce5c05a36dd0c425e0e7aedc0c86a3ab755641bb7ed1275abb"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
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