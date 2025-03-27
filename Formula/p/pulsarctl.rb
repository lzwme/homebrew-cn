class Pulsarctl < Formula
  desc "CLI for Apache Pulsar written in Go"
  homepage "https:streamnative.io"
  url "https:github.comstreamnativepulsarctlarchiverefstagsv4.0.3.1.tar.gz"
  sha256 "c306cc8f18013bb6680ecc1605ea54c7136493f97d942a27400cded659df64f1"
  license "Apache-2.0"
  head "https:github.comstreamnativepulsarctl.git", branch: "master"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to check releases instead of Git tags. Upstream also publishes
  # releases for multiple majorminor versions and the "latest" release
  # may not be the highest stable version, so we have to use the
  # `GithubReleases` strategy while this is the case.
  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "64c12b2cc3b2ab2d51aeb917e57355ac53f6357966918c6cebde1b6182a12048"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eabde173fcff42e7b56d1d7818ebd08a09084a4c2ba14ea5df106844cb19e978"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ccf029c0b1fd626e5b5b8724abf6a7eca2f1f17bd70013408bb476e07aac714c"
    sha256 cellar: :any_skip_relocation, sonoma:        "4e6090f20e4909f8613734d929c4271405e7f3f56b2e066398e0dc13d95a874d"
    sha256 cellar: :any_skip_relocation, ventura:       "39905c7b2b1cd65c8d8d4ee4a55d1d8b79520386f4ff9609b3722c33269019fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "51123143d9ccdaadd2c8c3b9903a7844a7a765014837612622c4a2997c903984"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comstreamnativepulsarctlpkgcmdutils.ReleaseVersion=v#{version}
      -X github.comstreamnativepulsarctlpkgcmdutils.BuildTS=#{time.iso8601}
      -X github.comstreamnativepulsarctlpkgcmdutils.GitHash=#{tap.user}
      -X github.comstreamnativepulsarctlpkgcmdutils.GitBranch=master
      -X github.comstreamnativepulsarctlpkgcmdutils.GoVersion=go#{Formula["go"].version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    # Install shell completions
    generate_completions_from_executable(bin"pulsarctl", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}pulsarctl --version")
    assert_match "connection refused", shell_output("#{bin}pulsarctl clusters list 2>&1", 1)
  end
end