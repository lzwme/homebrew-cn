class KubernetesCliAT134 < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/docs/reference/kubectl/"
  url "https://github.com/kubernetes/kubernetes.git",
      tag:      "v1.34.5",
      revision: "ebfac057369b21558006b8815821ab2fb1e29f2d"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(1\.34(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "111e4606965f129a573b7ab870066eb150c173574ab4c3467ba80f6ed94f224d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "83bf06cc6fb40eb8306bd344c93e7c381e8da9861daba7e189b95bdcbe590ebe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "16bd46bdc2370ed32c7285bd01d93b4316449a617a5b533153bfb5132109bc34"
    sha256 cellar: :any_skip_relocation, sonoma:        "92d678524f531a190ae4d3574b7f23104e9307181d231e435fbe49ab6c452429"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2af54dc497f81b378469b865272ff975069ecb1386176187224080175718b49b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b99d3ee03c12f69795b9ade3d31a1a1dad8bb08e50f6de5129b522365cb1f10f"
  end

  keg_only :versioned_formula

  # https://kubernetes.io/releases/patch-releases/#1-34
  disable! date: "2026-10-27", because: :deprecated_upstream

  depends_on "go" => :build

  uses_from_macos "rsync" => :build

  on_macos do
    depends_on "bash" => :build
    depends_on "coreutils" => :build
  end

  def install
    ENV.prepend_path "PATH", Formula["coreutils"].libexec/"gnubin" if OS.mac? # needs GNU date
    ENV["FORCE_HOST_GO"] = "1"
    system "make", "WHAT=cmd/kubectl"
    bin.install "_output/bin/kubectl"

    generate_completions_from_executable(bin/"kubectl", shell_parameter_format: :cobra)

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