class Pulsarctl < Formula
  desc "CLI for Apache Pulsar written in Go"
  homepage "https:streamnative.io"
  url "https:github.comstreamnativepulsarctlarchiverefstagsv4.0.0.2.tar.gz"
  sha256 "9bc33e0c660bb2e96b78cf2b1d7287601f2c97bf24efe06ff9416861debce472"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4e416e1c32713b67bbdc1d38b1e68251d49cb1f6dd4b4b59f9709d4cc6295493"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8bd144ef25fedb644e2202f7571c00876875763cf6dd37665c6fc72c0e653958"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a081153b8801e5cbe69bd8f71b4e574efb533f1cf54509843c7ccabbc80644bf"
    sha256 cellar: :any_skip_relocation, sonoma:        "3cc14b70340e1e6998ce606e7c52526a6000ff728044be7d7d911fb8ccffa098"
    sha256 cellar: :any_skip_relocation, ventura:       "3cc1cc53edf50e42fdeccd61cfaa141a437f02f5d978be38f908038fb694a50d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "03827a250dae76942e9279a83ae2aef7e3a153f6dc457588ef1ad6caf746206c"
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