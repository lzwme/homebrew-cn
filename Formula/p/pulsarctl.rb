class Pulsarctl < Formula
  desc "CLI for Apache Pulsar written in Go"
  homepage "https://streamnative.io/"
  url "https://ghfast.top/https://github.com/streamnative/pulsarctl/archive/refs/tags/v4.1.0.2.tar.gz"
  sha256 "9f75f3ba53711ebbcc0a0ddd7042ab295b8570c97d50c50b643fb3bc16b89014"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cdc97caf2118a695d4752aec632ac37365acd81fbfce245caecc18a5d7e5f458"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3680727e6c62cb1780e6405b6562270d249fff82898c506ed9c9d2a6c1cb7323"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7e7269b1cab0e9e069f587c2581a360ca9f765cd0d11e2c125dbaa75ad628e80"
    sha256 cellar: :any_skip_relocation, sonoma:        "4c8bf4f404f4c80c92a3ad161f22b00c16f26c154341bccb05d6e53073df2644"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eb9749828827322ded16355222f41692d8b845e11aa838fccb222b600d6591b1"
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