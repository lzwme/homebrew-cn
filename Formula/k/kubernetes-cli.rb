class KubernetesCli < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/"
  url "https://github.com/kubernetes/kubernetes.git",
      tag:      "v1.27.4",
      revision: "fa3d7990104d7c1f16943a67f11b154b71f6a132"
  license "Apache-2.0"
  head "https://github.com/kubernetes/kubernetes.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9f9e22602963585f9415691fd23c5603d194b9e4cdfb9187e8b38a451aeb9a67"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "922f33e2f38e660e8e8a36188bfefb42682e3883df306e625dc3f990d8b08daf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "020a9b8763cf2864ff28f5f92d8380f9a3809cb30431ab8a36aef4c3a85e2a19"
    sha256 cellar: :any_skip_relocation, ventura:        "edc6ced447d957b366526978d201d962aba11bb2555cfa160012eb56d15c13e5"
    sha256 cellar: :any_skip_relocation, monterey:       "2c0eb9dccb44d8f636c4f06e823329e8c24b94e88a5f3f2b72fa603e94ba8ad2"
    sha256 cellar: :any_skip_relocation, big_sur:        "5811cd0ddeee8a0bd155e843b29a65260e4cd3a0fd0a9750acc562f1a60a76ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a9d2d80152b16d4c6438b4f7075e43b3cd3cc5b03bf5ff1d76abb0b2b766c730"
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