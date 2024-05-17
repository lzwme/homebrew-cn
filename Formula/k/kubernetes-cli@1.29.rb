class KubernetesCliAT129 < Formula
  desc "Kubernetes command-line interface"
  homepage "https:kubernetes.iodocsreferencekubectl"
  url "https:github.comkuberneteskubernetes.git",
      tag:      "v1.29.4",
      revision: "55019c83b0fd51ef4ced8c29eec2c4847f896e74"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^v?(1\.29(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f0031d5d953b85243d7811c1ef82849b057f55a9ec768fea345bbffd78088844"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3518553090e47b0a2f96c51e3482e1bb197196a47eefb5d9dfc33a6c5e8b68e6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "722c2ce44b43a607ad365175c52bec160232face987d0b0563a838581550d477"
    sha256 cellar: :any_skip_relocation, sonoma:         "4b5dfbb34e2dc2b73a1f99489c3176814a563e63ebab297172364e57a0aad374"
    sha256 cellar: :any_skip_relocation, ventura:        "a02085f7e563ee6673beb87f8d4c7360b332dab289d45f21c1e901bb2ed9c0b9"
    sha256 cellar: :any_skip_relocation, monterey:       "8fdc94126316ce76e38b4e29162a6544758fa3190aea1749fb01333ca3d2402c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b719143fc15d689c4c5663cb030f12695c0bc309639972d140cf995386e92456"
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