class Pulsarctl < Formula
  desc "CLI for Apache Pulsar written in Go"
  homepage "https:streamnative.io"
  url "https:github.comstreamnativepulsarctlarchiverefstagsv4.0.0.6.tar.gz"
  sha256 "b7dbd606db7319d432ce88143df2d4ee01c19b52d7ff0f7f1cb4cf6d5ad592d5"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e06bf36a85d9dd37da2238a6ea35d379cdf18880eef47c6f2801db8207206c47"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f8e532302d840b208899f90cca8a07eb42c7050b839ab289155735eb89bc1668"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a0585af18fca4251310049d797ea8b5e393f107422b97c1a719c7544feda64a0"
    sha256 cellar: :any_skip_relocation, sonoma:        "e2e7a2ab17edceadff5d0e087ab150750e33ef7ab7289d8f1036a1b8bef48bf5"
    sha256 cellar: :any_skip_relocation, ventura:       "0b394de4108cf4e61eb9e6054fdbbd4a8b3eddaada014786675e28b555415f11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "592681db7136a09df51e8725978522ee24db3cc6acd7bbd4214353e46ba40644"
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