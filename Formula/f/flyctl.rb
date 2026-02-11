class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.4.9",
      revision: "1d59304448ff2c0a5e5b389efad4dd575ffc6a6a"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1aeae7578f016d3f1a6359ed4da33b65f6cf1942ecba6b3a04828255be007743"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1aeae7578f016d3f1a6359ed4da33b65f6cf1942ecba6b3a04828255be007743"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1aeae7578f016d3f1a6359ed4da33b65f6cf1942ecba6b3a04828255be007743"
    sha256 cellar: :any_skip_relocation, sonoma:        "71165f192d751f13d740f5e59b9fa9d6fc659c1bc32626fe475b8f97657273c3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "390def3f775d2116dab89925d2ed489391415c6e25d3bd6568877942f7e6ba9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c40b217e46fee2dcd5c63476e3fa700ef0c5603f6abcdf08677cf940744e3daf"
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
    assert_match "Error: No access token available. Please login with 'flyctl auth login'", flyctl_status

    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON

    assert_match "Create a new Fly.io app", pipe_output("#{bin}/flyctl mcp server", json, 0)
  end
end