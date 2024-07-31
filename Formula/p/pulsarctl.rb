class Pulsarctl < Formula
  desc "CLI for Apache Pulsar written in Go"
  homepage "https:streamnative.io"
  url "https:github.comstreamnativepulsarctlarchiverefstagsv3.3.0.8.tar.gz"
  sha256 "5df0476d2a79cc47047a9d5ef75cd55710dbb0879998d83712ca899e0bfaed4f"
  license "Apache-2.0"
  head "https:github.comstreamnativepulsarctl.git", branch: "master"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a94bda43ed82b68a3e7ee5c682afc4bd9197ec9552a2de0f76a6ea83a7dc72a0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "95caebef48def74119baade2348baf177a58cdf8d79b839ecd05be014ccf4acd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e38b7bc5fe20ed8de70ab2f3718ecacf0d25aa6651aa88e84bd1cf58f912c48b"
    sha256 cellar: :any_skip_relocation, sonoma:         "51485faba3b9ad34f3c02e80f5332c7424c80c183e25ee02ce4f743c6ec14eef"
    sha256 cellar: :any_skip_relocation, ventura:        "dbf8c5c22c6db202cb4063e93d3ef3a49ea43d10bac135434fd36c929dafe719"
    sha256 cellar: :any_skip_relocation, monterey:       "abf7530ddfaaefaa343cc5e56c0e7ec9d97d30296b42c207f603413128cb243d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d773f9185ec42851a323f5811a9d00b8831bb13fd18febd95f1302959d7e8a71"
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