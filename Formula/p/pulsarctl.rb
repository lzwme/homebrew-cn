class Pulsarctl < Formula
  desc "CLI for Apache Pulsar written in Go"
  homepage "https:streamnative.io"
  url "https:github.comstreamnativepulsarctlarchiverefstagsv4.0.0.7.tar.gz"
  sha256 "8b742338bc787f16c095c3948dc8d22bb4028e643b6a1ca31c6bbe971691a8fd"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a3620b7c0b479d18149f61b109ac7dd9ec32eb242adaffb87890837d189cb37d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "258db6460a698f34c6f02e033432e3b0251219971a620eb35a2734162ba67efd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "de63263c5daf52eb9b4818103c3c7b230046ab44b2dd308a18df862be218344e"
    sha256 cellar: :any_skip_relocation, sonoma:        "edfcdf3831d5683976a5a7b0822b70f31cdd2b3f90ff040899f41a9d6a830663"
    sha256 cellar: :any_skip_relocation, ventura:       "6fdff088e45f6e4fd8cc9432a08b7025ab0bfd766ff49e6604477f0b00f2586d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d930198b184008a4050fa5be72e4d25b9189c1a73d334e403f69eb7951b9bd67"
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