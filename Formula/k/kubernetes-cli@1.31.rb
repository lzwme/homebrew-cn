class KubernetesCliAT131 < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/docs/reference/kubectl/"
  url "https://github.com/kubernetes/kubernetes.git",
      tag:      "v1.31.11",
      revision: "7e94e1ce5c71407a782db8ef701e290bb0246da0"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(1\.31(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a545ab11adaabad8352d91844ad21fa1ad74262851a01aa03ebfd24cc7e24996"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3f2135b94294f85723f98d3daccf589fa7249f001d2184ea08c1e9b608729434"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "84d8e512b13fa7fc0dad661de6cac48abdbec18ead11c94b704c9e4e9393d5d3"
    sha256 cellar: :any_skip_relocation, sonoma:        "f8991feadfd25ee1e78037525a3ddc2ca8c750bdf08da6a5ff614560e04a423b"
    sha256 cellar: :any_skip_relocation, ventura:       "69f91aca07692fb2ef1bce2e804c6951d590e47c1b452f8d5b6844960092999b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7f3a299eb561661d3f191553a6c0a27aa09176e03aa8e7c2c42f9e850330b751"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f5a83a9b90ac0cde532224bfcdce27508a5809bbd065531bbbf3aaacfab1357"
  end

  keg_only :versioned_formula

  # https://kubernetes.io/releases/patch-releases/#1-31
  disable! date: "2025-10-28", because: :deprecated_upstream

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