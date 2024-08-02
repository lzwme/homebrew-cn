class Kubekey < Formula
  desc "Installer for Kubernetes and  or KubeSphere, and related cloud-native add-ons"
  homepage "https:kubesphere.io"
  url "https:github.comkubespherekubekey.git",
      tag:      "v3.1.3",
      revision: "b3bb8538ee7518282b733040b068639070c19709"
  license "Apache-2.0"
  head "https:github.comkubespherekubekey.git", branch: "master"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8415b288cafd85831504523d79503963b6dc409ee05a7390d896810b528081ef"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bd5aef341e4d94ab8a62c8c9bff9d855132d6c4e8fddb59cb276b7114d951449"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d862b90daee7c12ec1779dbe8798778316ef80956354bb50e592b869c8ff0391"
    sha256 cellar: :any_skip_relocation, sonoma:         "543f1ef2abe86d5a422b3c73dff84677f68cb5c19c19062d176eb10d15408bf0"
    sha256 cellar: :any_skip_relocation, ventura:        "4918b9c85b17afd8fa50e5525472ef0de6d906b8ab11c01eebd44a62c95c0d0d"
    sha256 cellar: :any_skip_relocation, monterey:       "4c116dfa99e986915c5b1750d1982ec7320baf703fa2da7c5aef8354eb35b968"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0581e0ae6d855048769d25a66ccf874e4caa9b73799a36ec34d08f05257c23ac"
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
    project = "github.comkubespherekubekeyv3"
    ldflags = %W[
      -s -w
      -X #{project}version.gitMajor=#{version.major}
      -X #{project}version.gitMinor=#{version.minor}
      -X #{project}version.gitVersion=v#{version}
      -X #{project}version.gitCommit=#{Utils.git_head}
      -X #{project}version.gitTreeState=clean
      -X #{project}version.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin"kk"), "-tags", tags, ".cmdkk"

    generate_completions_from_executable(bin"kk", "completion", "--type", shells: [:bash, :zsh], base_name: "kk")
  end

  test do
    version_output = shell_output(bin"kk version")
    assert_match "Version:\"v#{version}\"", version_output
    assert_match "GitTreeState:\"clean\"", version_output

    system bin"kk", "create", "config", "-f", "homebrew.yaml"
    assert_predicate testpath"homebrew.yaml", :exist?
  end
end