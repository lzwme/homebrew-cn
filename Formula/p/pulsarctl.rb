class Pulsarctl < Formula
  desc "CLI for Apache Pulsar written in Go"
  homepage "https:streamnative.io"
  url "https:github.comstreamnativepulsarctlarchiverefstagsv3.3.0.5.tar.gz"
  sha256 "33aec841c43ad734dbf942506b3b4e624419d202913b12e032ce92d29329de21"
  license "Apache-2.0"
  head "https:github.comstreamnativepulsarctl.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2ef07f39b50cc17e6288d1e64a8c50daf02045bb7b3442762d39ac3f67866ece"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e4a6b5c010b1c5d574e67ba80a1bb58da3226ab6d5a07e0c5cff2271262d09fc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e013c30c7ebc5f312c455d329dde793891f2d4adfc2389bae4fa6d3ea758e6cf"
    sha256 cellar: :any_skip_relocation, sonoma:         "35b5ced4e965994698c2a14b36853c81155d1a608c764460f3bd7c62c5989672"
    sha256 cellar: :any_skip_relocation, ventura:        "0f0dbb5ac87ed7bd7994740993b33553cac65431aa657cae4e9a3e17dc4c7fed"
    sha256 cellar: :any_skip_relocation, monterey:       "bc1b8db35353c9daaf14618e82951b320586f49074a513fa382dfc1c88f94a75"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a8b44a7a701ef2729d24914098a6ded2bd81ff2f37fc689461105e2fafc773ce"
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