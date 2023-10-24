class Kubekey < Formula
  desc "Installer for Kubernetes and / or KubeSphere, and related cloud-native add-ons"
  homepage "https://kubesphere.io"
  url "https://github.com/kubesphere/kubekey.git",
      tag:      "v3.0.12",
      revision: "b2f957f81b011db13024128efae942a7e9cdfdeb"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "868f037322c21e7fc0d46361bd06d0900b7cbd18c58d7a6f467134f764a944f5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b24ffccbd1b1dcd33fa845de614f50b0b26e7d23436c2508157e61297a700b38"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b7ef5d7ba10b31c1c0d9c7c3a940b0c450d867edfbd040c1509c30cc0327ac1b"
    sha256 cellar: :any_skip_relocation, sonoma:         "d6790588db305d57f0f25d060bb1e2458f134b330355e588d58f3e0c798e9231"
    sha256 cellar: :any_skip_relocation, ventura:        "6b97f0414c6ad7e27a029f0594a26caa0726fd98f3bd1c37af79ab939f1018b1"
    sha256 cellar: :any_skip_relocation, monterey:       "a24cb058f46b0420fd8487a21ff7a2f719dba39ca6f50e64180b437e8952e72c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "460f09047590ecec829837e5f93910294a7ca5c3b010ef7c3d539ed8a23c66e7"
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