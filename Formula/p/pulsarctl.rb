class Pulsarctl < Formula
  desc "CLI for Apache Pulsar written in Go"
  homepage "https:streamnative.io"
  url "https:github.comstreamnativepulsarctlarchiverefstagsv4.0.5.1.tar.gz"
  sha256 "60131175ba22e8464c20a1fa5ae9bb7597891f55dede28a2d2ebafc5c53ccfa9"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "10390b41a673df679dd47cf5dfe98d2fb2613795e498bca3c79a05c7556e2fce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9fd23f1ccd128a479aee07748fc89b1d46c8e23982a693d298a3261df7f1aa97"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7681a2714ae2a96eaf688aedc903c75f021902a4d4316205a0bb67310676aa5d"
    sha256 cellar: :any_skip_relocation, sonoma:        "3b4c4d2ed5cccbd3a1ed8fbdfd03862079cebfba2c04f3be1074a98b4a5412ab"
    sha256 cellar: :any_skip_relocation, ventura:       "dc4b085a577c7a0f5633bd026a108d8a904929eebd4314fd8cda06e028ff04c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "88524ee5e3988567c8083e2ede3e1f6e41057b36100c5c82bb52723f6142aee8"
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