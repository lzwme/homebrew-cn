class Pulsarctl < Formula
  desc "CLI for Apache Pulsar written in Go"
  homepage "https:streamnative.io"
  url "https:github.comstreamnativepulsarctlarchiverefstagsv4.0.1.4.tar.gz"
  sha256 "2928c9dd14650cd7efb8dfe4a50814cbce788a35e147ce49ca4e76b8509bf3e4"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f422a6599f533b82388c26977bd0e2139026d266dfe72a6d4c6e004d35b6f989"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "03c725ddc12c7c7f45263d06e6aaf6c0af1ead8145f3d07194ece10070951125"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c4fd01631da2f29948027841f1b208199cded90ee8140a4be70a2356a9d99f7f"
    sha256 cellar: :any_skip_relocation, sonoma:        "5961db98287dd68c543c7178d32f18a482915b761674cf31f8ef253a05fa32df"
    sha256 cellar: :any_skip_relocation, ventura:       "6e7ceeea8ad4d97de8987b593eb907e0d0c54ea4de2f347d1d381beb6f452914"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "745412df1eff5b54811cd7723b20c8a8e1676dca8e1a0c42a1fd1ac050cc55dd"
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