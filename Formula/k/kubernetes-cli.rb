class KubernetesCli < Formula
  desc "Kubernetes command-line interface"
  homepage "https:kubernetes.iodocsreferencekubectl"
  url "https:github.comkuberneteskubernetes.git",
      tag:      "v1.32.0",
      revision: "70d3cc986aa8221cd1dfb1121852688902d3bf53"
  license "Apache-2.0"
  head "https:github.comkuberneteskubernetes.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "83f41dddaff07d9a1b81536f9efef3074976555741125b5650e83f0a78c2a0d6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3c077fc014d4684fcb56068a0871be83e39258a184a5bbd2e950474af6dca2a7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "67c2ac8db6b9a2aff60f14ec5d825496e3f371e26f0d717ba474629c4e7b1e80"
    sha256 cellar: :any_skip_relocation, sonoma:        "2b7f0d7cec2554add02321d0152e5877f395e48647e3ddab78a7e6f56d180810"
    sha256 cellar: :any_skip_relocation, ventura:       "248711e05c4b424404a3f75c089f8c43a4abfdba78ddfb3c20d3eca054ad2f60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "60a07c101e87d349530e540f8baf9ae504048caa3cfdc37ecdba0a11bf2beb19"
  end

  depends_on "bash" => :build
  depends_on "go" => :build

  uses_from_macos "rsync" => :build

  on_macos do
    depends_on "coreutils" => :build
  end

  def install
    ENV.prepend_path "PATH", Formula["coreutils"].libexec"gnubin" if OS.mac? # needs GNU date
    ENV["FORCE_HOST_GO"] = "1"
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
    assert_match stable.specs[:revision].to_s, version_output
  end
end