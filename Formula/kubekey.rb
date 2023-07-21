class Kubekey < Formula
  desc "Installer for Kubernetes and / or KubeSphere, and related cloud-native add-ons"
  homepage "https://kubesphere.io"
  url "https://github.com/kubesphere/kubekey.git",
      tag:      "v3.0.9",
      revision: "b752cc6a5753e021a5f83937e3a3f004617d8374"
  license "Apache-2.0"
  head "https://github.com/kubesphere/kubekey.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f701535ddf6eab6145559d355ed6137c5cc176241a2ae29f8ae4e8496d3d066b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1392416f487664b277e50cc3f17e39a1cc77550c6d18ad4cccaac52606d4b6e6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d707c5b97204407d8ee66fc0c11a28d3218ddeead5b62ccc4360bd6babdcaec1"
    sha256 cellar: :any_skip_relocation, ventura:        "f8573bf658b1dc9e1758cc002b4497b19410b4b5dac14df7066f4b3028f7cd89"
    sha256 cellar: :any_skip_relocation, monterey:       "ec107c24f4c3ac74630fd299f07af68251840901a68a0c2bbbcc348b2bdfaede"
    sha256 cellar: :any_skip_relocation, big_sur:        "8a090073a0c9c16574711fea21dd17cb453680cd06a042dd45c5e691b7c561d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cd8a5c2052152dfb083cc11ab02f1638df477ce28d6c53c688230404d6d824d9"
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