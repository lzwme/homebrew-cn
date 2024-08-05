class Pulsarctl < Formula
  desc "CLI for Apache Pulsar written in Go"
  homepage "https:streamnative.io"
  url "https:github.comstreamnativepulsarctlarchiverefstagsv3.3.0.9.tar.gz"
  sha256 "f0fb9c47f21f489b66370092995db529b32c7c5bac057b817bb5303c059652b9"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d048bbd600d112f0341d8af676bf85d5cf5f0501e3eabe26be0e5a7e10821dda"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "92648c001552a199920ba80ae71d8111161b23dc12ef1ddf93147eff3fc03b16"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9d54a9f5c612da4d1734a700a17cf9b6e5f06615ff84b1bfea46e9c4a6b37866"
    sha256 cellar: :any_skip_relocation, sonoma:         "67dd6dade58e3bd792f1581a267bfabce9928b95acbc60b9a19373bed359a524"
    sha256 cellar: :any_skip_relocation, ventura:        "602625e8d5aec904888d1e3d1a31af0e506641ced173ba6b870d88a213e29fb0"
    sha256 cellar: :any_skip_relocation, monterey:       "2cc9dd871f0eab86d0ff44adaddfdd4ec4062376bff609c599b67eb646024574"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "87174560732d783b7824680eb49db87beec59bf3606aa01209c5557f2631dac9"
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