class KubernetesCli < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/docs/reference/kubectl/"
  url "https://github.com/kubernetes/kubernetes.git",
      tag:      "v1.35.0",
      revision: "66452049f3d692768c39c797b21b793dce80314e"
  license "Apache-2.0"
  head "https://github.com/kubernetes/kubernetes.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "94d25794c27019df7a3602fbbf6a6f4549392fd2771d59d479f8378d07f3df02"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e0bbb19355da98430e2a926afc42c928cfcb90ef40cfdac6d105fc300310df96"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "36b539ed5abce3653bdd50aab69acf5dc60043ce17243fd890089e590a77f8b2"
    sha256 cellar: :any_skip_relocation, sonoma:        "60320f39390aceb60d870c474e5167b86c445cb645c2797080657ab28e41a3c9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ee4b6d39cf8ab5ff6a8df95c43ab1d5411e980b7223a55889b95debdfbb6ea4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f539db32926f96cb3f2e4fd422f15106aba6b640fcc45d0ba78aa3d92683d2bc"
  end

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