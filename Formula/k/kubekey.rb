class Kubekey < Formula
  desc "Installer for Kubernetes and / or KubeSphere, and related cloud-native add-ons"
  homepage "https://kubesphere.io"
  url "https://github.com/kubesphere/kubekey.git",
      tag:      "v4.0.2",
      revision: "bd780ee397ff2abcc5d03975c32dae056ddb86c5"
  license "Apache-2.0"
  head "https://github.com/kubesphere/kubekey.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8ecca1ee4a5b9902714dfed90abc22bcdc8cdef71a95c6cbc211338c927a1f19"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8ecca1ee4a5b9902714dfed90abc22bcdc8cdef71a95c6cbc211338c927a1f19"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8ecca1ee4a5b9902714dfed90abc22bcdc8cdef71a95c6cbc211338c927a1f19"
    sha256 cellar: :any_skip_relocation, sonoma:        "1f79e1a124c48c2cbc93eeffc0ff887b1025b05ca2f3d962c77a999535b696d4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a0bb9587e59c7e15cf59d844588b65fb110377a718769dae8f42f8a33be8bd16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "af468947eef9b76fd53e7ae0475cf9831292a145465dc05a12960f05f1c065f7"
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

    generate_completions_from_executable(bin/"kk", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kk version 2>&1")
    assert_match "apiVersion: kubekey.kubesphere.io/v1", shell_output("#{bin}/kk create config")
  end
end