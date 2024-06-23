class Pulsarctl < Formula
  desc "CLI for Apache Pulsar written in Go"
  homepage "https:streamnative.io"
  url "https:github.comstreamnativepulsarctlarchiverefstagsv3.3.0.3.tar.gz"
  sha256 "8171726d64266b569fae1c6b7fadcc99f90e4117aef2e71ff54f992afbc7939e"
  license "Apache-2.0"
  head "https:github.comstreamnativepulsarctl.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3877f915e14d667f5a843246dc2dc0a883ee275bb59bff665096ec579628991b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4e6cd405b1dd04699a32b518452fc042e8223d2f218742ecc7cf529daba0a3d0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ee8530293b9fd5f12df0fa7d420af64276491f89eb60eaffe50aedf6e911f517"
    sha256 cellar: :any_skip_relocation, sonoma:         "f9b378a94ca49e1de77c8df47650ac8f83334d82f71e58d1ca881dbe50fa386f"
    sha256 cellar: :any_skip_relocation, ventura:        "e23fe7c645052757252585b9ce5c7521aaaf34ff4a1462da5736b23cdbb29182"
    sha256 cellar: :any_skip_relocation, monterey:       "98e94cb0c080cf66a0d5e5c0adb0841568ee1a7bb8fb7381d0a2b9e5c7c44ab9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "362884eccc65416cfe1cda7f12dceee9ce490d4293150ea3c238c08940c333c1"
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