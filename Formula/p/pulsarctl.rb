class Pulsarctl < Formula
  desc "CLI for Apache Pulsar written in Go"
  homepage "https:streamnative.io"
  url "https:github.comstreamnativepulsarctlarchiverefstagsv4.0.1.2.tar.gz"
  sha256 "3da490798e9a0b4a2247c4a6f2502f4336c51bc711e7aec8b58a69e9a5d90c18"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "893ac0303c0b9533301525e8dcd564c36918e5e8155ee53f4c25176c24b307c3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cee38112ccdd39d740ff989e5e6736511a73e16f2b5276c8ec053d6841de086a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2c31c7db21360f63544d04b14ef384d211cdcf615a0454daf3d0198674befeda"
    sha256 cellar: :any_skip_relocation, sonoma:        "a3c0b6ffc163bc369a479ccf059609bfe5ffdaefdedb57b4d731859d95a420b4"
    sha256 cellar: :any_skip_relocation, ventura:       "32812e91b309891466f4fe55e97569451d757ffe9744acda6d01dee1e7660e93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fae63a85df3629750df180cf251b851d2497c6e03dd6ed44a3872fb8c1ccf255"
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