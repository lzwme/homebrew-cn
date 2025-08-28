class KubernetesCli < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/docs/reference/kubectl/"
  url "https://github.com/kubernetes/kubernetes.git",
      tag:      "v1.34.0",
      revision: "f28b4c9efbca5c5c0af716d9f2d5702667ee8a45"
  license "Apache-2.0"
  head "https://github.com/kubernetes/kubernetes.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e087de2d43ff65d7065515a5fde6837c950a65ac81fa34dee4ee4d2fe37baaca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4f52dcfae7d37bfba99ec5b2ab03142074020cb13c4de1eba7a020222b258538"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6944a5bd8d0fcdb5cb8e5c43dac32344177179030538f2e7ce306431a823ff59"
    sha256 cellar: :any_skip_relocation, sonoma:        "dd4eaaab7c7cf303b1fed7c0d5de0214dfa69da1aacb835bc94258572bb5060d"
    sha256 cellar: :any_skip_relocation, ventura:       "d5de4b53933db0d7e785327b8b028ce466c355f19145bb5454e01bbb05d19017"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5f6a586de22d49392d37064ccae36ac8e2c383f12f505e2b6c0019b0a46a27d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "faf2bb9110608a0bcf82905f2d6422eb61ed135e12e0447230bcb32b7c76086a"
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