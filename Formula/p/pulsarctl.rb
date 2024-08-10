class Pulsarctl < Formula
  desc "CLI for Apache Pulsar written in Go"
  homepage "https:streamnative.io"
  url "https:github.comstreamnativepulsarctlarchiverefstagsv3.3.1.1.tar.gz"
  sha256 "c63d785cde7872d80859722ab0ffb468c85700e2bcd896450284157a74d1ac31"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8507801c9cbf1b61bb61584d3af8c211b5560054bbb42184de36d6c09f7e20b1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cc5e41afb71f6682084a390dabf9bef793a7ba2ad2a8fdcf4a1834e3f8f4e1b6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0ea8cd1c1760b6810a2033aeab55960697c57a2d6e0ad772fbb5ae8b67ec0c32"
    sha256 cellar: :any_skip_relocation, sonoma:         "8d07549b7620cf0461529f9da7bcf384a68926b375a30f989ffe589ea8d6f78d"
    sha256 cellar: :any_skip_relocation, ventura:        "fd97bb68cfc318c0ccb3383b09c470e4c7b5b50d971850b2d11e5c4873291c1a"
    sha256 cellar: :any_skip_relocation, monterey:       "4d3ec6f89a0f8e32be510749d6ce68e1cba2b7a866772da4253f2a71ec509234"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2cf8497ad8c138d26db599a385244b46c95ab760a3dae9e66cfcaa0ddeea5073"
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