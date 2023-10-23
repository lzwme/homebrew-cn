class Kubekey < Formula
  desc "Installer for Kubernetes and / or KubeSphere, and related cloud-native add-ons"
  homepage "https://kubesphere.io"
  url "https://github.com/kubesphere/kubekey.git",
      tag:      "v3.0.11",
      revision: "19a0ad13399135a009302df8e19dde4cb9879a08"
  license "Apache-2.0"
  head "https://github.com/kubesphere/kubekey.git", branch: "master"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5959a4022506846860bbc0fe25016cb17abf02adf84dabdb8947a521eca3783f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "caa502b6b1689731dcfebc039acd1cab97b5ec0900936329f7d0157b879c1db9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a756749c31b9a007454a932ceed6c1a02c9c2360779339de8bcb4de0fef41421"
    sha256 cellar: :any_skip_relocation, sonoma:         "89c95488d236110d0a58aa7877a8e67e14161e534be8ce20003740237e6cdcc8"
    sha256 cellar: :any_skip_relocation, ventura:        "90221c780b4e527a808ab6f80ed213bca5f7e201ebb45c54c160e136887add05"
    sha256 cellar: :any_skip_relocation, monterey:       "b1b92e74b633b83ce1890f77aad80075b5afc4ca671e049911d0abc4c5dfbd18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d44d76ec8045f6371f07abbc3f476de5e397609a933939bfb85fb5a06c141a03"
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