class Pulsarctl < Formula
  desc "CLI for Apache Pulsar written in Go"
  homepage "https:streamnative.io"
  url "https:github.comstreamnativepulsarctlarchiverefstagsv4.0.0.1.tar.gz"
  sha256 "ae0264eec214c4db8f14f738dad02c14fc0e2b5b306d72888e43711928402b6c"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "db7acc2fa7fc760105b9e3d5fbb8bf16d96c3da4d2cf24456fb7e80a345aad72"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2bc6ca5fbfab3ebb665c041dcd106d4de29febce15c9659d327700e0523789ef"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "099da7c7fbe1d93f36fcde5c421f8cc0d3ce6fe731543ef97219e4f38b194d29"
    sha256 cellar: :any_skip_relocation, sonoma:        "fd5087ba139558fac057e46d59e23c60c9609462f000e80fe2f35c019a51f6cb"
    sha256 cellar: :any_skip_relocation, ventura:       "51418f3f5ddf8c490e2e1d06af619d87ca551d5dc4f4f11759a4394df6626d36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a80dab2c9039625db2ba1f3b52f96e1d77d33bb635641da142dd7b2dee27915e"
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