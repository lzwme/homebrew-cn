class Pulsarctl < Formula
  desc "CLI for Apache Pulsar written in Go"
  homepage "https:streamnative.io"
  url "https:github.comstreamnativepulsarctlarchiverefstagsv4.0.0.8.tar.gz"
  sha256 "3403567320c9c02049db54dcf575e694b1fbad57f8d6fbdc32d8f8119c02d737"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "63c79ca5d85be8e6cc88f0a81a342fb8fc23cb82f0e0105c352d65155afb4db4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ab233b041df9cae49025a5eab1134e91f35ab65a637fb2dd2cc3f07b87ff593d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "455259283ebdf18f7fb26b6fa030e0101386e0469b97b297661d2848004c1b57"
    sha256 cellar: :any_skip_relocation, sonoma:        "039a99b6b1f111a22bd2e4eee4db160f4de1fada48fd7b0db85cadf9927525e7"
    sha256 cellar: :any_skip_relocation, ventura:       "d8afd6b37d9aeceebda40a232cc20705bd6a9e26f7999ec4e8f6485716c59b5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d73b23f66d3e7192ea8d33dc654e5f6c5a2719933b16ca3ccec8c80c2fe0c671"
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