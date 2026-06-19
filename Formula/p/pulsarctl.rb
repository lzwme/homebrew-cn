class Pulsarctl < Formula
  desc "CLI for Apache Pulsar written in Go"
  homepage "https://streamnative.io/"
  url "https://ghfast.top/https://github.com/streamnative/pulsarctl/archive/refs/tags/v4.2.1.4.tar.gz"
  sha256 "6ff48caad8d7d74c5fa3098ecd72ff9eeff0f131c2a730c1dfc34d212b6ba6ff"
  license "Apache-2.0"
  head "https://github.com/streamnative/pulsarctl.git", branch: "master"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to check releases instead of Git tags. Upstream also publishes
  # releases for multiple major/minor versions and the "latest" release
  # may not be the highest stable version, so we have to use the
  # `GithubReleases` strategy while this is the case.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "db866b5d83aebc741bf524497e45214cbc70d12b7e74af84dabfd8d6fb210873"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "db866b5d83aebc741bf524497e45214cbc70d12b7e74af84dabfd8d6fb210873"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "db866b5d83aebc741bf524497e45214cbc70d12b7e74af84dabfd8d6fb210873"
    sha256 cellar: :any_skip_relocation, sonoma:        "66891ac2b8706c608a3903e892dcd7090e0d4dbc07a962311e4a545f8a96861f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "59005708e3fad89e0fc101d24e010d6b2d7e6519ed9701d4fffe00f4822e4e34"
    sha256 cellar: :any,                 x86_64_linux:  "ba3b677808253dd36a52e2e9f7ac75905f98b555d9b22ca97fd55066b1ab69ae"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/streamnative/pulsarctl/pkg/cmdutils.ReleaseVersion=v#{version}
      -X github.com/streamnative/pulsarctl/pkg/cmdutils.BuildTS=#{time.iso8601}
      -X github.com/streamnative/pulsarctl/pkg/cmdutils.GitHash=#{tap.user}
      -X github.com/streamnative/pulsarctl/pkg/cmdutils.GitBranch=master
      -X github.com/streamnative/pulsarctl/pkg/cmdutils.GoVersion=go#{Formula["go"].version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"pulsarctl", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pulsarctl --version")
    assert_match "connection refused", shell_output("#{bin}/pulsarctl clusters list 2>&1", 1)
  end
end