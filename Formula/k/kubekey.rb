class Kubekey < Formula
  desc "Installer for Kubernetes and  or KubeSphere, and related cloud-native add-ons"
  homepage "https:kubesphere.io"
  url "https:github.comkubespherekubekey.git",
      tag:      "v3.1.4",
      revision: "09effbe07af6fa1b9d0e54590ba678db341b04db"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "48644cefc0490ad10985018744c444ca93c3f527cf65af3d99f38855f45cf07b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ad6b23070a98621206490d6da7ec087d4025c4cb9564ed366e50c7de190a6869"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1ee01233749e1e7bf4a6e12d918e7f25e488eb9f9bdf3083828629ed16ac8ca4"
    sha256 cellar: :any_skip_relocation, sonoma:         "141179d2d40d46d441119d208e14b766786591b4a341b1e7397a225659f31a54"
    sha256 cellar: :any_skip_relocation, ventura:        "e533a6ca89702d75648c166d318f400be87f4b0ddffa84b482d2d59d747ee116"
    sha256 cellar: :any_skip_relocation, monterey:       "8cf3cf7225e75a91c9654990449752ecd428d84665f03edfdea42f76826e4364"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea5d77f79770c2d4f375aca28c73829ac0a9b56bf27f871cbe93f5bb9786ef33"
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