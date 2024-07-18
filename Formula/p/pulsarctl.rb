class Pulsarctl < Formula
  desc "CLI for Apache Pulsar written in Go"
  homepage "https:streamnative.io"
  url "https:github.comstreamnativepulsarctlarchiverefstagsv3.3.0.6.tar.gz"
  sha256 "e61be0befa5beea6bb04a98ca2c81064cb1c82e06375f0db9aa9f9d5e59c56b5"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "28dc9aeefbc1ea3abd4df8f21e138019ef64ca581d1d9876728bb5ffd2263e24"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "13ccbd0f87b9893215f28cfca90f6c0a342a08a92388302afce3c41f44749468"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "46d546157972785f871f868f5f1678d90baaf2670c07d4e2e417f292acaaf762"
    sha256 cellar: :any_skip_relocation, sonoma:         "6142e4cd3cfcb0de908d36ecf22d0ae0fa67e498c0710e2c6d67d8f6b98c1138"
    sha256 cellar: :any_skip_relocation, ventura:        "52e18b3b48f34b16ed0dd1a91051ebc2fbad1ec8df0bbe8fb3d6f66682c59b24"
    sha256 cellar: :any_skip_relocation, monterey:       "bc2a90826aa9f792c7545e2011e336010a2b6c1f00dc44d5b76e8d2c51c50aab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "59c841cb82d90a7c38d346b31498652120346ef62621bf424190bf29bcb460f7"
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