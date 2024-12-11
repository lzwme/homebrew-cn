class KubernetesCli < Formula
  desc "Kubernetes command-line interface"
  homepage "https:kubernetes.iodocsreferencekubectl"
  url "https:github.comkuberneteskubernetes.git",
      tag:      "v1.31.4",
      revision: "a78aa47129b8539636eb86a9d00e31b2720fe06b"
  license "Apache-2.0"
  head "https:github.comkuberneteskubernetes.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b9fe0f9cd026cb4f99c357aff52583e054646671165df1fc7408b71aecca50d8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a9acdfffe8cf3c221fb9c17b5f3b74e80913cf1779f8648ae00dcf4238eb0df6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "943f3ab41b867ae87e207da57ae1a5fc7fc580bea28fe8f483630285f8fcc0be"
    sha256 cellar: :any_skip_relocation, sonoma:        "e5ee97cba7db145d8eb1a0ba98af64a49edffc421e9bc9fe567718cbdbe35095"
    sha256 cellar: :any_skip_relocation, ventura:       "2bb2f456f565103c92602375c315de14a3ee9494b4bf759b800e738fd9a0a8c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e147852002b7ee09d1a4cf860ae6bffc0deb68954cb5f2202c5c1e1f08757c5"
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