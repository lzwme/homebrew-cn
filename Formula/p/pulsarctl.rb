class Pulsarctl < Formula
  desc "CLI for Apache Pulsar written in Go"
  homepage "https:streamnative.io"
  url "https:github.comstreamnativepulsarctlarchiverefstagsv3.3.1.5.tar.gz"
  sha256 "b0f1e86ef345da4a16b64fc381ea7f63a61b6a3ddd66748564f24902461ca9ac"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "aafde61205094527b7ee85edb5cc46f0d31bb10962a0ae166ff789c4bd256227"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7773a92c4150afb304c25c047d087b124c572246bb9eb5d961f992571d7ec54c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "723b3e59e346b26f81cba3bea1081fd336baa58d38288f8b01e7a8ccd1c73302"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fb85e21bd0a06ff9b07543451963fb6a2fdd0a928eef11d38f18f8d37e98bca3"
    sha256 cellar: :any_skip_relocation, sonoma:         "e30d03c70b8b1308b6613f1b9795f74c11c2f1960cab1f3d757642d29902855e"
    sha256 cellar: :any_skip_relocation, ventura:        "2eb16b186d64dae80ebac36bbe48a7f1b9b24c8fdd17938b84249d3ef631d9c2"
    sha256 cellar: :any_skip_relocation, monterey:       "adadeb68d00338c8b263c80039065558f5d61733954cb683a3546d454da6f62f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eca535afbedf89100ebe031e6e0d6cbfa3d3e1927923e43fd9e2927413cdec0a"
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