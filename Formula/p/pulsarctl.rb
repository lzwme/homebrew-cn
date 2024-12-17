class Pulsarctl < Formula
  desc "CLI for Apache Pulsar written in Go"
  homepage "https:streamnative.io"
  url "https:github.comstreamnativepulsarctlarchiverefstagsv4.0.0.9.tar.gz"
  sha256 "7c419f9481d19550c67c989d9605c481ea13f6cfc23521a464975df7d8b50b84"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6b60da7dec6bf827116d6937aaf4c45140984f0a9f48cefa263364918a124b5e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d49c5b54a0d3317a7b0e5794ee90470fe227c6100b1f9d296f740d1fff8ec6ce"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "66603cdc2368e6c6c7187a2a2461cbfeda4829e25bc19845ae627f625f9043d9"
    sha256 cellar: :any_skip_relocation, sonoma:        "3f793301ffe2c09ea43de974833c0ecc158c6782bbf814b22949e09cc72bc985"
    sha256 cellar: :any_skip_relocation, ventura:       "03bc8dc38942f2c45bb79707f915b504d5757f924cbe7250da54e518dd8e75f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "262a2e01885a01b93614bfafeb8b4d0fa50d4720fbdf41d19b341b2e43f7412c"
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