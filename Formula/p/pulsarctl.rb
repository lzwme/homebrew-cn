class Pulsarctl < Formula
  desc "CLI for Apache Pulsar written in Go"
  homepage "https:streamnative.io"
  url "https:github.comstreamnativepulsarctlarchiverefstagsv3.3.0.7.tar.gz"
  sha256 "51efd225e705fe9fa8258a2ed9efbd33eb4f9a1b22e1fd55d1f6991a05423031"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "47892a0f9324ed560e1c940c3c4a68ca204a94bcf0d062e505cfba179aa52ee1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f005d104219d1a6886115566474515bdb44aa658e1dae77c74e77babed9feeac"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fdf593c7cc028fbcc876caee780180df4070434e6672fc8b2552bdf824dddd5e"
    sha256 cellar: :any_skip_relocation, sonoma:         "b7b70521693a2f29af28309f45d01b7cf1bbe372042e61a9601b74882db3b701"
    sha256 cellar: :any_skip_relocation, ventura:        "a87211af440994cf0e414677b343797adfdf186c38b777c9f47e472625b91e45"
    sha256 cellar: :any_skip_relocation, monterey:       "db08edf6813f8748b5b093e97986bcd188ba2ea240daf43264df7fe64de7f89d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c0f0097d03ed9e90386129bb32b779d933b60a7f84ad24e60d485510ae10db6"
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