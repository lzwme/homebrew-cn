class KubernetesCliAT129 < Formula
  desc "Kubernetes command-line interface"
  homepage "https:kubernetes.iodocsreferencekubectl"
  url "https:github.comkuberneteskubernetes.git",
      tag:      "v1.29.10",
      revision: "f0c1ea863533246b6d3fda3e6addb7c13c8a6359"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^v?(1\.29(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "26ab171bd9590f15fd648fb1cc65a6d1a22f91eb2417a9d3f71664b21bf0edea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f49ee808ca5ab3d15d3b8c500ff875c19309907467fc7e3da84be59912d9643f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1f8c48e629b4f14e971059c2ed197bdf14ddab38b66a92ce759e01e4b0907895"
    sha256 cellar: :any_skip_relocation, sonoma:        "4a16918ef7f4349e198ab95965ccf108b5d4258e3a0479bb399b69a7127d4e9a"
    sha256 cellar: :any_skip_relocation, ventura:       "b6ce2c1923138751ede16f3fc3b12fc8ff558f2cc8764185391acfa6679cb7f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b7342ec98ef6ba994ab3c913f3ba5f8009cc2c01aa8ec703986a856b8426919e"
  end

  keg_only :versioned_formula

  # https:kubernetes.ioreleasespatch-releases#1-29
  disable! date: "2025-02-28", because: :deprecated_upstream

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