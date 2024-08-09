class KubernetesCli < Formula
  desc "Kubernetes command-line interface"
  homepage "https:kubernetes.iodocsreferencekubectl"
  url "https:github.comkuberneteskubernetes.git",
      tag:      "v1.30.3",
      revision: "6fc0a69044f1ac4c13841ec4391224a2df241460"
  license "Apache-2.0"
  head "https:github.comkuberneteskubernetes.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "997269d89ad1a95bb8146f107aa8b8a003bc26039758b77e6e78b8cb402142c8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "82a8f89348e6430d267c181258abcf31ea815f5fba0252e79deded73ca8fefa4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "397cd89b7dea8acb4ab444e031c77f8aa903d642138cec10f0bf8b0801a565eb"
    sha256 cellar: :any_skip_relocation, sonoma:         "d6a7432ceee48003bb468af9b9a0dee7d0992f282642c0711003d82fa2db7969"
    sha256 cellar: :any_skip_relocation, ventura:        "60d0c7e9aec82f81f3c9203ab0e556028e34b60e72c8570a5d558a1d4e3e6f63"
    sha256 cellar: :any_skip_relocation, monterey:       "77977c7d9c39d7acb22f2646b5eeaf5e1d35f8b8757c802b236856c49d7e6e9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "04ee2a03dbf08b173a32b2a3da5cf526c8a0df029597582023f1b2bf0af9d9e6"
  end

  depends_on "bash" => :build
  depends_on "coreutils" => :build
  depends_on "go" => :build

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
    assert_match stable.specs[:revision].to_s, version_output
  end
end