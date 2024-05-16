class KubernetesCli < Formula
  desc "Kubernetes command-line interface"
  homepage "https:kubernetes.iodocsreferencekubectl"
  url "https:github.comkuberneteskubernetes.git",
      tag:      "v1.30.1",
      revision: "6911225c3f747e1cd9d109c305436d08b668f086"
  license "Apache-2.0"
  head "https:github.comkuberneteskubernetes.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "771ad075fdf99fca2849f1fdc5679dbd49b5415e723aa925cc3c4ddb43a77867"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9e9c2bb7f2d3a7d87369a8fd73134f85322c60129190b4c638c4d47dc57f5fe4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c388f894724280c4384f14536ce59e7b8db409c999d60c694fa53e87398e065b"
    sha256 cellar: :any_skip_relocation, sonoma:         "b5d6983ee5165ff37b8d61208004a8cbbdb66e27db946398e0a68063e63f81e9"
    sha256 cellar: :any_skip_relocation, ventura:        "da67cad8fee4e3ae42bc921377613cc6c038623999084035aa527acf33c2e6bd"
    sha256 cellar: :any_skip_relocation, monterey:       "0a7c1f60e912571bd9b179d087e30a6ed1f0d08cd113c7f159768c919ba7e7e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "341997f08c67b3da4b3bd64bee156fdeb71593363fbe87bdde632c8cfa58aa7b"
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
    if build.stable?
      revision = stable.specs[:revision]
      assert_match revision.to_s, version_output
    end
  end
end