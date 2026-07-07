class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.4.67",
      revision: "050e26f31add9233660b627d527673746c52cd90"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aac4d9ef2c9e1c9c9a81d44f074305807e261e27bc8d4bc0392c6edab3e376d8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aac4d9ef2c9e1c9c9a81d44f074305807e261e27bc8d4bc0392c6edab3e376d8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aac4d9ef2c9e1c9c9a81d44f074305807e261e27bc8d4bc0392c6edab3e376d8"
    sha256 cellar: :any_skip_relocation, sonoma:        "e2ac8868f0ece28943def3c9878d448d29a32518815fab04b0ba151a505f17b7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c42ff19829266dda1317d34d9c04aac5bb9067a1d91e4ccfc91ff5de5d129baa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "28099e76906290c5eff04b7c2ed17a4a504b37abe65450b4c391baaea4dd78be"
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