class KubernetesCliAT133 < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/docs/reference/kubectl/"
  url "https://github.com/kubernetes/kubernetes.git",
      tag:      "v1.33.7",
      revision: "a7245cdf3f69e11356c7e8f92b3e78ca4ee4e757"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(1\.33(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "90ed24b9e22019137cb4bdcbdaca49a5bb20b02a37fe05e4ba04d2f7cf722ca7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3244a781c7db3acfdecc31a91de660fa7f4282b46345f23db4f5027a88e349ba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b886f7285e190d0c08f9e4ca2a677be93a048e8f025fd70c386e0f38f7c4322b"
    sha256 cellar: :any_skip_relocation, sonoma:        "6185eebbf4c2e4c573357b780fd3b1ae6bdcca9097d52ac8827ec1eb2952b9c6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cfe36a61c8b636c004287ebe5dd45d6bb0a0f8e40c267cafadbaf2487d127589"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fc63a097fb7763938178907a12dfecc91c3b944f36114e98a27294a9733ff66d"
  end

  keg_only :versioned_formula

  # https://kubernetes.io/releases/patch-releases/#1-33
  disable! date: "2026-06-28", because: :deprecated_upstream

  depends_on "bash" => :build
  depends_on "go" => :build

  uses_from_macos "rsync" => :build

  on_macos do
    depends_on "coreutils" => :build
  end

  def install
    ENV.prepend_path "PATH", Formula["coreutils"].libexec/"gnubin" if OS.mac? # needs GNU date
    ENV["FORCE_HOST_GO"] = "1"
    system "make", "WHAT=cmd/kubectl"
    bin.install "_output/bin/kubectl"

    generate_completions_from_executable(bin/"kubectl", "completion")

    # Install man pages
    # Leave this step for the end as this dirties the git tree
    system "hack/update-generated-docs.sh"
    man1.install Dir["docs/man/man1/*.1"]
  end

  test do
    run_output = shell_output("#{bin}/kubectl 2>&1")
    assert_match "kubectl controls the Kubernetes cluster manager.", run_output

    version_output = shell_output("#{bin}/kubectl version --client --output=yaml 2>&1")
    assert_match "gitTreeState: clean", version_output
    assert_match stable.specs[:revision].to_s, version_output
  end
end