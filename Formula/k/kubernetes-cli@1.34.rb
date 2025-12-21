class KubernetesCliAT134 < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/docs/reference/kubectl/"
  url "https://github.com/kubernetes/kubernetes.git",
      tag:      "v1.34.3",
      revision: "df11db1c0f08fab3c0baee1e5ce6efbf816af7f1"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(1\.34(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bc996eabe837f4cc195c22b732d0c9076c21270b589e9e634b9c88bb4d3f3fd8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3d25fa75b7eced68467950da9a1f8052264e39725468c4048ec18d48f01fc6a7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "37ef791b26fff253cc9b2829105df60a178d01d015e983cf991a1a12f4e437ae"
    sha256 cellar: :any_skip_relocation, sonoma:        "5f62627739fcc9a86f0e6b75e5896b30cda24c1a15f38a3b463c6da4dadc26e3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "167e5d458b44e2f47bbcd584f6dbcbc33848191ce2f77cab2398c3c55dacb7b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1c6ed95b4f152f02bd8a6a210d3d117d6c01bb53564d39f96166cd05bac65f85"
  end

  keg_only :versioned_formula

  # https://kubernetes.io/releases/patch-releases/#1-34
  disable! date: "2026-10-27", because: :deprecated_upstream

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