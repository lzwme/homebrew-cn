class Pulsarctl < Formula
  desc "CLI for Apache Pulsar written in Go"
  homepage "https:streamnative.io"
  url "https:github.comstreamnativepulsarctlarchiverefstagsv4.0.5.2.tar.gz"
  sha256 "23d1a759de7d150cf3b133a6958cf31035a584ad7b7b297a95eedb4e76cf35de"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "893e3bbd9c3e190f5f8b4ff8731a8799394fad100c55c2f7ba168fd4475d4c0e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "39d875c520db76d8c503dd08016be2c167b4856d14eede0152d6e0810431aaeb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6d3f8842e2145ebb016ce4b9ce09866978be11d6e336831b78e6b356af012f2b"
    sha256 cellar: :any_skip_relocation, sonoma:        "3b80d664d182dede6ba057ec5794ed8c00a5523dbb1227affc41c35d748524f3"
    sha256 cellar: :any_skip_relocation, ventura:       "72f3be6fc0c8cd08fa2d3150a1f3988a922e5a211cebf0c29bb885d7e3500de7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8aafda1ec6cda272cf8495079124fecc21d6372cd5fc9b823ad7462dec2718f7"
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