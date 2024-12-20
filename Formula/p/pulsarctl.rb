class Pulsarctl < Formula
  desc "CLI for Apache Pulsar written in Go"
  homepage "https:streamnative.io"
  url "https:github.comstreamnativepulsarctlarchiverefstagsv4.0.0.10.tar.gz"
  sha256 "0e19a304ec9456cd8ee9eed4acbbfd39a8e061733b3c6e862f14c0b80125c03c"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "217b6958fb2435c4781ac0b9a6941a29ee287ebed8ccf3fef9c36df2600c9464"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "48ac6f64821a610c35b669b50996f60e50296bdb01955525d056d8af82f3bf3b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cb32c2017c61370ccafd61e1ae25446073b805a22b14112876fca4e4da3a3875"
    sha256 cellar: :any_skip_relocation, sonoma:        "831f5b66115320d518412dd8cef2f9db9c088c405242a9f064ec5bbea6a397c2"
    sha256 cellar: :any_skip_relocation, ventura:       "1e284f1403d8fc0cfdaba7ea2f1db3e0c899c2d8fc6d2ecd9b26795ef75050f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3223e5dec7a85e2d65fee0fe002ac9cc2e75f103a581dd1fde4ba466e710a185"
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