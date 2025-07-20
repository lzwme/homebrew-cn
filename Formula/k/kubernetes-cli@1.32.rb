class KubernetesCliAT132 < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/docs/reference/kubectl/"
  url "https://github.com/kubernetes/kubernetes.git",
      tag:      "v1.32.7",
      revision: "158eee9fac884b429a92465edd0d88a43f81de34"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(1\.32(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4a3a2908a3da625ec368b89eb5615b8f677fce4398dc2f63c9f7373cb237a4c4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b7662522c584cd26514628bcfcab9d361798d9fdb9ce2eebf1fa4cbd4f67fb55"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "495b98693bc95886fcdcf72053f0641e0f39fd5fb66bb7d9793c59f6d33dda1e"
    sha256 cellar: :any_skip_relocation, sonoma:        "461466326441875c0a4030526c3ccf353eae5db76ac44b5e549d71ad97bef2c0"
    sha256 cellar: :any_skip_relocation, ventura:       "cfb431ce26510cc542a887dc79ff24bfc009d883edf8ea4bc22d88bac0ccfa16"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "af7604bc277ebd445d3701df99ef46f2daf041b6bc9c79e38e9bf19e0bc13dd4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d4de8caffee90eb7c55c4f9c01d63bbc4f13c2d84ba69f4aa7839460f571c04d"
  end

  keg_only :versioned_formula

  # https://kubernetes.io/releases/patch-releases/#1-32
  disable! date: "2026-02-28", because: :deprecated_upstream

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