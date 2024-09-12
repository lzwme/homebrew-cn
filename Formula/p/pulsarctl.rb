class Pulsarctl < Formula
  desc "CLI for Apache Pulsar written in Go"
  homepage "https:streamnative.io"
  url "https:github.comstreamnativepulsarctlarchiverefstagsv3.3.1.4.tar.gz"
  sha256 "7d1b564588e4e25e5dc85848bb9152567b374f21ae2f9a7810caf0d6381aaadb"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "893037c46c216591b6b2da8ea01b1117251b1bd99438d7b5ca3235fae69b7920"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "19f7eadd75ab4255af830d38c25586f5b9508302e4570bdd3846ec3c83ea7657"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0a2fb8ef9f51fb0bb0c06fb272d586112c84a467247c59ba413dfc50175df3cb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bc2c2f3963c96ee765165c4c0fd7c2503ee3d652a5a34e74446b89f5a104cf93"
    sha256 cellar: :any_skip_relocation, sonoma:         "46ec62154babbaa3f558be2ef903ae76b04578a4bc8c69a6ec47b8cd09982c58"
    sha256 cellar: :any_skip_relocation, ventura:        "4d036ba125a8620ae8d2472818d776e39ecbe73cf8c2acce38856446fb02e470"
    sha256 cellar: :any_skip_relocation, monterey:       "fb1212879bdf0388a8a114fa4e2c9352955ae538592497102462654594567f44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ebd25ece0b9b06827feca94f0d79755c6d78209278d9b4b4d50c29d6c7588d9c"
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