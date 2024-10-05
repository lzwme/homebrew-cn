class Pulsarctl < Formula
  desc "CLI for Apache Pulsar written in Go"
  homepage "https:streamnative.io"
  url "https:github.comstreamnativepulsarctlarchiverefstagsv3.3.1.8.tar.gz"
  sha256 "cfd3493cd2116c625048d9b23715dd474da4b8a3bb6c27365f7f90328fb2ec8c"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dd8e37d00d22d688adf6957c2ff171290e77fc402698df3c89c9d7a34d12ae47"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "137c783ca54b9a56ca5e5e985fdeab241d92793595752a0301737a05ef8b46c8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fa0a3bbf92d117020a08185462e184bfcba1c281bdec876652dcab03e10c7821"
    sha256 cellar: :any_skip_relocation, sonoma:        "4fc9a3b2dcb8fae8ad0286d38607b0271ab617443d5999b8a47df7227e021e0c"
    sha256 cellar: :any_skip_relocation, ventura:       "99da3238780189df25afd82b2c4ddbcf05464d680ec4d38ad906266ab8283227"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "203fbab1217d6249285c301cb483377a98e47c415e7bca4e88e6992352d84a26"
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