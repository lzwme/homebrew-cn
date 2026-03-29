class Pulsarctl < Formula
  desc "CLI for Apache Pulsar written in Go"
  homepage "https://streamnative.io/"
  url "https://ghfast.top/https://github.com/streamnative/pulsarctl/archive/refs/tags/v4.1.3.4.tar.gz"
  sha256 "8e989752834e8dd7b72d36f19de55163e4b1c1afba3b76d2964eccc82188b7ff"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a5f70afa1ef6d3058abb4c78328619696634664c40df269a5803905724720559"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a5f70afa1ef6d3058abb4c78328619696634664c40df269a5803905724720559"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a5f70afa1ef6d3058abb4c78328619696634664c40df269a5803905724720559"
    sha256 cellar: :any_skip_relocation, sonoma:        "1b0cdfda6d37ce45c4d984c954d99552706d4b6a2a295b897ec7952762f5be9c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fdc938ef710b273ba49f3816bdd346e3ef2ee1b774aca11736c84b3b26f41350"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "35d7b9a11be7c198f38f7a5df3693b6bc083f81c9f89563fcc613a6fed1fd0ec"
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