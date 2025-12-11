class KubernetesCli < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/docs/reference/kubectl/"
  url "https://github.com/kubernetes/kubernetes.git",
      tag:      "v1.34.3",
      revision: "df11db1c0f08fab3c0baee1e5ce6efbf816af7f1"
  license "Apache-2.0"
  head "https://github.com/kubernetes/kubernetes.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "92304e1a5ab255a6abaa726ce4d7951000d082f45886b2ac61a9fc79ed61a806"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d5eedf3d8b983652827f7d877df7c4274307d8c1936ca06b08f6ef20b310030b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c612e2875a5eec527513b14bf4c31f1cb820e27b3141a92b1b79444c66965048"
    sha256 cellar: :any_skip_relocation, sonoma:        "203b58e04e049b7cbebcf6fcf632b44f45ff410cf657254f0c35e739aaad06d0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6147312dd455504754d106f0ed93c59af5ae9c58ae40838c9e6b7ca1db95c40a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a2d007a06ae08e58533d28043a6c5b8dfafca2bd1b66ff0e68ed8ed9bc0f1b4"
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