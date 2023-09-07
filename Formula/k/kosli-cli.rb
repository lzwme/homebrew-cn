class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com/client_reference/"
  url "https://github.com/kosli-dev/cli.git",
      tag:      "v2.6.5",
      revision: "8f4dc320cd81002b2e2f83516e679f3b0e685168"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "969f0e104b0dc51f5b0d01f2f30c78fc0d1f67ede1e8afe0877e4505d518ca11"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a6f93d1c0c1d477300564fac41f8b82b3e5a66ca63567b3052097bd3a2158dd8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "99181c4245ccd35bcee7774f7dd6824e745641e52b5061762b5905ac24b0c9d7"
    sha256 cellar: :any_skip_relocation, ventura:        "e4197a804a42ca5440bcd11006bae7a7e94f75b5a6aa0325ce4da6124c7cdb1f"
    sha256 cellar: :any_skip_relocation, monterey:       "d02974d01106b5150fbaabcc59b8332b40fdcc2891f1f127add7111d0830e693"
    sha256 cellar: :any_skip_relocation, big_sur:        "1a3fbdc86526e014ca2fd7169e44ef99db5b62ae19c293440cd04ac0070bfe93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f6761f9c7a6e1865cf6e9b0a6437fa0eb5c634c45faccdd774d9d8399c66277e"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kosli-dev/cli/internal/version.version=#{version}
      -X github.com/kosli-dev/cli/internal/version.gitCommit=#{Utils.git_head}
      -X github.com/kosli-dev/cli/internal/version.gitTreeState=clean
    ]
    system "go", "build", *std_go_args(output: bin/"kosli", ldflags: ldflags), "./cmd/kosli"

    generate_completions_from_executable(bin/"kosli", "completion", base_name: "kosli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kosli version")

    assert_match "OK", shell_output("#{bin}/kosli status")
  end
end