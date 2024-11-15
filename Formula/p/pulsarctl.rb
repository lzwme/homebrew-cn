class Pulsarctl < Formula
  desc "CLI for Apache Pulsar written in Go"
  homepage "https:streamnative.io"
  url "https:github.comstreamnativepulsarctlarchiverefstagsv4.0.0.4.tar.gz"
  sha256 "b46750182c320340e2187746ecb7147e8910d458f656bd340d0fb0cfbd6399c0"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0d87af160db9bf885f2b3c4ce5121a11c322dfe9ae407674fff830572913caac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6d182a8108c15593307f89319fe23eb7159377e801759514db077c160f6f9f7f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fb19932cf68827a2dff1b68e029dfeaaa9d21da451af23bc49dcf974aefddbce"
    sha256 cellar: :any_skip_relocation, sonoma:        "2d56f0c1809b1f269d21bfe327fbece45c453a914f1f4c061e043e24f79e1475"
    sha256 cellar: :any_skip_relocation, ventura:       "8c890e4f4ab5b4be617f2eb4f432afe494f910ea46aa52fec48c0780a484d044"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a870cbf406b399f8626289273f9bc7dafd1492a75accf6f205cd336858f3f2ae"
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