class KubernetesCliAT129 < Formula
  desc "Kubernetes command-line interface"
  homepage "https:kubernetes.iodocsreferencekubectl"
  url "https:github.comkuberneteskubernetes.git",
      tag:      "v1.29.7",
      revision: "4e4a18878ce330fefda1dc46acca88ba355e9ce7"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^v?(1\.29(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c11a7686388adb42bac0d61d03f9fe38f3541d854b4bf671c9ddc62781e3b8e6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2eef1dc46e8467d6a27b8716e29dbdb004f6077988b9e1b898f0e5e9dc44b919"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e908fc84d9fea81bc6cc12a82e7bcd5491d9496c816b9fe99655adfdf1d4e1f6"
    sha256 cellar: :any_skip_relocation, sonoma:         "a014cd1bbd0f782a2465c1deecef33d60ce668e61ea5423a58a7f1f7f674a676"
    sha256 cellar: :any_skip_relocation, ventura:        "4b6d170a66b9e00a567e31b6e9dfc8717059fc227d641dd0ed57a59cdd97fb8a"
    sha256 cellar: :any_skip_relocation, monterey:       "bf3341290056341fbe6ecf096e283e7c11148be904b7c1e73c33eed36e9a9195"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8680be648f50562da21f4fc3a90458ebea2253d580c6a8171a082732d7d25f8a"
  end

  keg_only :versioned_formula

  # https:kubernetes.ioreleasespatch-releases#1-29
  disable! date: "2025-02-28", because: :deprecated_upstream

  depends_on "bash" => :build
  depends_on "coreutils" => :build
  depends_on "go@1.21" => :build

  uses_from_macos "rsync" => :build

  def install
    ENV.prepend_path "PATH", Formula["coreutils"].libexec"gnubin" # needs GNU date
    system "make", "WHAT=cmdkubectl"
    bin.install "_outputbinkubectl"

    generate_completions_from_executable(bin"kubectl", "completion", base_name: "kubectl")

    # Install man pages
    # Leave this step for the end as this dirties the git tree
    system "hackupdate-generated-docs.sh"
    man1.install Dir["docsmanman1*.1"]
  end

  test do
    run_output = shell_output("#{bin}kubectl 2>&1")
    assert_match "kubectl controls the Kubernetes cluster manager.", run_output

    version_output = shell_output("#{bin}kubectl version --client --output=yaml 2>&1")
    assert_match "gitTreeState: clean", version_output
    if build.stable?
      revision = stable.specs[:revision]
      assert_match revision.to_s, version_output
    end
  end
end