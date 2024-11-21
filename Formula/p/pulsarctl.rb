class Pulsarctl < Formula
  desc "CLI for Apache Pulsar written in Go"
  homepage "https:streamnative.io"
  url "https:github.comstreamnativepulsarctlarchiverefstagsv4.0.0.5.tar.gz"
  sha256 "3521008ba0ea3d53f7fdbfc51d4894b6e0272de5a9725ba2c670ac9ca5271421"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cebfad573caa50418e7efff05366c316c725df8235a0c61f3f6c2feffee5a2eb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f3ced38cff5a105efa7edd03345791baa75dc46264e6aa57906cb758d4d2848e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bc7b805a553d52953f121be115925e88d13bfe7b64df7b0d0caccc5b253b1ca4"
    sha256 cellar: :any_skip_relocation, sonoma:        "7a24e959682a5bb494218f81ebcd4995d5ec66cdd08b6d350e7ec85b6ce0e74e"
    sha256 cellar: :any_skip_relocation, ventura:       "f0dba992e9d0f397cc6d56957ecc45b8b0403aa74e29d87b617694f426c726b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "762cbaac5ac157149a9000a35ff448076f972d685ed0954110b0a11fe3516851"
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