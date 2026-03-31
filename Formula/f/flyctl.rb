class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.4.28",
      revision: "bac398fcb592d50affba8cbc6c56ab312358bfd7"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7ab8715e466d56df2aafbeeb39db738929f29a888345c09d7f988e63c395e01f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7ab8715e466d56df2aafbeeb39db738929f29a888345c09d7f988e63c395e01f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7ab8715e466d56df2aafbeeb39db738929f29a888345c09d7f988e63c395e01f"
    sha256 cellar: :any_skip_relocation, sonoma:        "39a52e09599470651d82bbe533efb9042fd6d051fa740c05c68914a0f3d1c032"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fb00b3706b24d7110f94ec2114481761b5eb2ac425de59d10cf93da666579482"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e306052a48186a65f640dee36e8a57ebdb12cc43abefe064d16e94d8bed1d258"
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