class KubernetesCli < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/docs/reference/kubectl/"
  url "https://github.com/kubernetes/kubernetes.git",
      tag:      "v1.33.3",
      revision: "80779bd6ff08b451e1c165a338a7b69351e9b0b8"
  license "Apache-2.0"
  head "https://github.com/kubernetes/kubernetes.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f288a307a11c7ffae443ff101f8c1e09ea0433b8e7ac0eb315572cae379c46b8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ef98d36293197b032303fe6bc94e1d377c9edd053fd2b2d04e9338b526f10f4c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3f34eb991e82ac8725c2b13ebf9b18e3f055e6ace28a8cd8da411363a06393c1"
    sha256 cellar: :any_skip_relocation, sonoma:        "1248eb0a319c459505f81735d856fcf1b8db7a20ef58c9c503b1fcf751c8b777"
    sha256 cellar: :any_skip_relocation, ventura:       "f0bfd44a0c329dcaa90f9cc8f2573d11009699798c8959d34fc1129b5bcaede8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1a9ac27a7314bad76a2790d9d9a756927c68868d1154fc96f47abb4421c84bc9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4dcadf206f3f796a44c451c970dc5827aa15e18bf347a8600c4d0de670c72e8b"
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