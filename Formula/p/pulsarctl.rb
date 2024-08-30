class Pulsarctl < Formula
  desc "CLI for Apache Pulsar written in Go"
  homepage "https:streamnative.io"
  url "https:github.comstreamnativepulsarctlarchiverefstagsv3.3.1.3.tar.gz"
  sha256 "f8a4f5ecc22488d886a7eede7bbff76113f0e484dfe3c3750de5657d84503640"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d7908c11fef43451270951a37d96eb5db9b6dcd25d814d01bb22313c591c954f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "217f8a91de6e91e458a69f7eed1ca116cff566f155d0992575cbea624f724c79"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dbe71deba79023b6193df0cfffcad317c0d0f21c8b51722e6a86eb6c5cab40ff"
    sha256 cellar: :any_skip_relocation, sonoma:         "b056ea981a022389d0839957e98f4ea74414cc3fb31eae9287604458c698b301"
    sha256 cellar: :any_skip_relocation, ventura:        "33d24e96517a0934251054878fd2f6d4da9b61a243aaff11ec8f0fb507537837"
    sha256 cellar: :any_skip_relocation, monterey:       "618b71003baf0ad95b47cc88347028a6e882f90f90549d0451f6ea1b9f9fdb3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a17ee319ce3adf779a923621c70d7ecb585695e9e18c26cbe3d4db2c9edb8d3e"
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