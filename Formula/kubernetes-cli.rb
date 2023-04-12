class KubernetesCli < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/"
  url "https://github.com/kubernetes/kubernetes.git",
      tag:      "v1.27.0",
      revision: "1b4df30b3cdfeaba6024e81e559a6cd09a089d65"
  license "Apache-2.0"
  head "https://github.com/kubernetes/kubernetes.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "10370fafa0a71526ab9c42223061dfc766082207eb8417f91caee6828e48e385"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a787a6e7ff9ae10f062b8a084455f050f726c1b3bbeb1c68e4d541abcdedad19"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dafd7d389ed628277f5f34efe9cfa8efb41eac020bcb31ee2473f7a745592ccd"
    sha256 cellar: :any_skip_relocation, ventura:        "66632870f640cda5fd9ea1df4cad1ab165e5fa30ab27ed810f750704036b1956"
    sha256 cellar: :any_skip_relocation, monterey:       "63c32670c234f8ac831bb213bdb1834b363f3640f522eb0c3d95f5bfd8ed6aee"
    sha256 cellar: :any_skip_relocation, big_sur:        "e59c7ab5888d2b3668209941c28c06e892a88cf65cf8a6876f42ca0d56bc93d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "709fe48183512beb0c91d488a41b0bcad701756373bdc53588aad55cc665c047"
  end

  depends_on "bash" => :build
  depends_on "coreutils" => :build
  depends_on "go" => :build

  uses_from_macos "rsync" => :build

  def install
    # Don't dirty the git tree
    rm_rf ".brew_home"

    ENV.prepend_path "PATH", Formula["coreutils"].libexec/"gnubin" # needs GNU date
    system "make", "WHAT=cmd/kubectl"
    bin.install "_output/bin/kubectl"

    generate_completions_from_executable(bin/"kubectl", "completion", base_name: "kubectl")

    # Install man pages
    # Leave this step for the end as this dirties the git tree
    system "hack/update-generated-docs.sh"
    man1.install Dir["docs/man/man1/*.1"]
  end

  test do
    run_output = shell_output("#{bin}/kubectl 2>&1")
    assert_match "kubectl controls the Kubernetes cluster manager.", run_output

    version_output = shell_output("#{bin}/kubectl version --client 2>&1")
    assert_match "GitTreeState:\"clean\"", version_output
    if build.stable?
      revision = stable.specs[:revision]
      assert_match revision.to_s, version_output
    end
  end
end