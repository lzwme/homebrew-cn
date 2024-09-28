class Pulsarctl < Formula
  desc "CLI for Apache Pulsar written in Go"
  homepage "https:streamnative.io"
  url "https:github.comstreamnativepulsarctlarchiverefstagsv3.3.1.7.tar.gz"
  sha256 "60896abac2268053aae50d6d0b91bd98ddcf20e5179e6e7aba8c8b6644df9497"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b9c065e221eda85f42c0232d38e990c7229d237cb8f16265ce9830f48fd8d4bd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ec56f475b1a44ea84da31823097afea63cf2e4562698bdbefd1e92aa0433e99e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1a3b78789e03f265286dde3837f6ba43137b0dac5d69005f6099c54ca3feacf0"
    sha256 cellar: :any_skip_relocation, sonoma:        "ca262cb8a063d29f3bd1979b9ba0ee10a17d40e97f893b99ac90207b3e136f53"
    sha256 cellar: :any_skip_relocation, ventura:       "d11a1e73bac9384b0b37150dfc00bffeefe08fc623d4a38108e9180c1eab3fb2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b66f44f07d9e12b3d7c2f2a4c3d61d68daf83f0cef6782226538175f34ecb28a"
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