class Pulsarctl < Formula
  desc "CLI for Apache Pulsar written in Go"
  homepage "https:streamnative.io"
  url "https:github.comstreamnativepulsarctlarchiverefstagsv3.3.0.4.tar.gz"
  sha256 "5951a62b0b0450c738815b26ab409494927043f1e681aec9b518df710339227b"
  license "Apache-2.0"
  head "https:github.comstreamnativepulsarctl.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c3fa6632b1839d881ab808086658434af776e160c53d141ba011bb8ed722dfc6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "518e8925a55097d4cbf320698f4b321111a637297d1134eae3a93dfab8f95f1f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "63af50f1295b6bb363878193e9460b864a995e8c5e35a0ed7541e86edb931946"
    sha256 cellar: :any_skip_relocation, sonoma:         "7b95cabc2e2f0dff3fac4e89b34b946a81088d30d84cb835d5fa18b09e6c7403"
    sha256 cellar: :any_skip_relocation, ventura:        "5d5b947027be3c3d202c9d705f6c7d165dbf9e1e77582c9fa6c20e8372459ac7"
    sha256 cellar: :any_skip_relocation, monterey:       "89fb076f5df08037f14cc2c1d9a78f31ccc82bb8bf48b2e51c290491b24135f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6918cc1542f96ac8029cafdbd5b493e595b93d1adfa70c0ea2df18ee88aa3944"
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