class Kubekey < Formula
  desc "Installer for Kubernetes and / or KubeSphere, and related cloud-native add-ons"
  homepage "https://kubesphere.io"
  url "https://github.com/kubesphere/kubekey.git",
      tag:      "v4.0.0",
      revision: "0381d075cf2b56583060b2f9ed26f8c743eb6ce7"
  license "Apache-2.0"
  head "https://github.com/kubesphere/kubekey.git", branch: "feature-gitops"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "22305a1283c8ff0e5a26eff40669ed13ea7594a869fc5f2a6e99dbf4e781fbd5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "22305a1283c8ff0e5a26eff40669ed13ea7594a869fc5f2a6e99dbf4e781fbd5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "22305a1283c8ff0e5a26eff40669ed13ea7594a869fc5f2a6e99dbf4e781fbd5"
    sha256 cellar: :any_skip_relocation, sonoma:        "731200a5a944a0acc739daca3e4ccf7f7675a84f05284999e6ed816cce1fb3b6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8419e7ccedde545aef36ba6df5dc4f7aec600d7d37eca4871ce4df64fc0608bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b307dbcf28d186bcdbc03c3d7be09cc9739f4eebc65b5ae5bb4c16e76a47c382"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build
  depends_on "gpgme"

  on_linux do
    depends_on "btrfs-progs"
    depends_on "device-mapper"
  end

  def install
    project = "github.com/kubesphere/kubekey/v#{version.major}"
    ldflags = %W[
      -s -w
      -X #{project}/version.gitMajor=#{version.major}
      -X #{project}/version.gitMinor=#{version.minor}
      -X #{project}/version.gitVersion=v#{version}
      -X #{project}/version.gitCommit=#{Utils.git_head}
      -X #{project}/version.gitTreeState=clean
      -X #{project}/version.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:, tags: "builtin", output: bin/"kk"), "./cmd/kk"

    generate_completions_from_executable(bin/"kk", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kk version 2>&1")
    assert_match "apiVersion: kubekey.kubesphere.io/v1", shell_output("#{bin}/kk create config")
  end
end