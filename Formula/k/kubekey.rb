class Kubekey < Formula
  desc "Installer for Kubernetes and  or KubeSphere, and related cloud-native add-ons"
  homepage "https:kubesphere.io"
  url "https:github.comkubespherekubekey.git",
      tag:      "v3.1.0",
      revision: "54b5d7a51c42027bfcc250dc1ecbbab028563aaa"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f93fcb8f42ee85f1ea449385b4bd134086eac340553a49f099e208bde38ffe71"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8c906d0a1476eca4d6a8e72cef5eb0d51d89decf9e91e1f743681d5583fc3876"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0121c21b0800b6993af2e7abfc71b0163ed2f96c372b4c4981d2620af0bc5b46"
    sha256 cellar: :any_skip_relocation, sonoma:         "c8ea524e19faa4c3ffb48bbc0a3e8de57d1c88aa951385f0351d779e51a817ac"
    sha256 cellar: :any_skip_relocation, ventura:        "9064ead867af33a6dc89ee845d5271f4432c9ae1b895bfd29c88a5f50a2d8e85"
    sha256 cellar: :any_skip_relocation, monterey:       "6b69d1a799d2c892d397905e63236cb3244978fc1ce3b58526699f448a865cac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "183d5932576db1ea8be3c1793967cc62e0bff951ba18dd3bba493adea1cacb09"
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