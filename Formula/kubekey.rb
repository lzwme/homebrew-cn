class Kubekey < Formula
  desc "Installer for Kubernetes and / or KubeSphere, and related cloud-native add-ons"
  homepage "https://kubesphere.io"
  url "https://github.com/kubesphere/kubekey.git",
      tag:      "v3.0.8",
      revision: "2698dfbc5781a0fdf3ba587797676dd91c9f8274"
  license "Apache-2.0"
  head "https://github.com/kubesphere/kubekey.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aa3009f5af48066de81df60b541361e7b874d8a640bb9720b65b1617aafe2a45"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3068ce6f520c3c311d3f6f297951f5b77f4336b2d3d621b1e4329581722d68ac"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a491224e82f626c7e3412456196d6620d6fd1d849fbeddc1655c1f02e50f9c8b"
    sha256 cellar: :any_skip_relocation, ventura:        "9085cd05814edb29ad9a6587f0c6c41c39010b93ef668f12f14bd2351baf2d8a"
    sha256 cellar: :any_skip_relocation, monterey:       "a08ffdf20dc96e62d8153fe2b5766325c5003ea1624a0cb4b154a57a2250b05a"
    sha256 cellar: :any_skip_relocation, big_sur:        "1189b8c74f7f6f6958be3d60112e66f6713d1d384a281eff841e066d417e9d10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9fcaefe3212a430c14901d690bfa7165c64d4921330fffe0ee21171c445da845"
  end

  depends_on "go" => :build
  depends_on "gpgme"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "btrfs-progs"
    depends_on "device-mapper"
  end

  def install
    tags = "exclude_graphdriver_devicemapper exclude_graphdriver_btrfs containers_image_openpgp"
    project = "github.com/kubesphere/kubekey/v3"
    ldflags = %W[
      -s -w
      -X #{project}/version.gitMajor=#{version.major}
      -X #{project}/version.gitMinor=#{version.minor}
      -X #{project}/version.gitVersion=v#{version}
      -X #{project}/version.gitCommit=#{Utils.git_head}
      -X #{project}/version.gitTreeState=clean
      -X #{project}/version.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags, output: bin/"kk"), "-tags", tags, "./cmd/kk"

    generate_completions_from_executable(bin/"kk", "completion", "--type", shells: [:bash, :zsh], base_name: "kk")
  end

  test do
    version_output = shell_output(bin/"kk version")
    assert_match "Version:\"v#{version}\"", version_output
    assert_match "GitTreeState:\"clean\"", version_output

    system bin/"kk", "create", "config", "-f", "homebrew.yaml"
    assert_predicate testpath/"homebrew.yaml", :exist?
  end
end