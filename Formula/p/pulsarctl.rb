class Pulsarctl < Formula
  desc "CLI for Apache Pulsar written in Go"
  homepage "https://streamnative.io/"
  url "https://ghfast.top/https://github.com/streamnative/pulsarctl/archive/refs/tags/v4.1.0.10.tar.gz"
  sha256 "0236b921e3f5a9493d4c2f40568acfd5d367b1e08bf3028e2dc94755f9b1620a"
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
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "db7806e76da272d79c2005f8ede835945e46f5e140fd80b58c935019a5319eb0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "737aa408f5e67c3a56f347d58ee6742fafb7f5e490f9730e5f946376532eddef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "87c1e5933e69f989c34c025f8c00533e8c83587634f0991e737726e9ddb2c42c"
    sha256 cellar: :any_skip_relocation, sonoma:        "85442f259221a678b338226e04c70eef422b582b02e0143d06f983958603409f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "02ef4337fceb3e6b0196866b94cd5572a31e95391a8eda8b7b37757b97fac063"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9d3b4568b12b24acdaba8d3bb97474be4acd8fe52f8c2d3907407bb4d5f0775e"
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

    # Install shell completions
    generate_completions_from_executable(bin/"pulsarctl", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pulsarctl --version")
    assert_match "connection refused", shell_output("#{bin}/pulsarctl clusters list 2>&1", 1)
  end
end