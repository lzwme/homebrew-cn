class OpenshiftCli < Formula
  desc "OpenShift command-line interface tools"
  homepage "https://www.openshift.com/"
  url "https://github.com/openshift/oc.git",
      tag:      "openshift-clients-4.12.0-202208031327",
      revision: "3c85519af6c4979c02ebb1886f45b366bbccbf55"
  license "Apache-2.0"
  revision 1
  head "https://github.com/openshift/oc.git", branch: "master"

  livecheck do
    url :stable
    regex(/^openshift-clients[._-](\d+(?:\.\d+)+(?:[._-]p?\d+)?)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "64cc5dcf7bf07f668f4acbdba2dcf8d1e567594a410448b33ad04056831cfb36"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b9b738a51a182d3f2a43cf609bf2962b252b2cf5372db42feb71ee2251e9cc17"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "be3035d53cdd8662ad946147a8ee4adb121d56ee9c6d5083548b25c729789e2a"
    sha256 cellar: :any_skip_relocation, ventura:        "5fdfbb50f0f136774df1b96fcf5e914a789bcca7bb3c3ca7e3bcf75ce7286ee5"
    sha256 cellar: :any_skip_relocation, monterey:       "41e04b0f9f0bb358b34a91a9487537ad2a655d4ac0a60bc21468a00ad8db9b2d"
    sha256 cellar: :any_skip_relocation, big_sur:        "bb0cda775ae23aae53d8b2f9d4523f6e90a484a961ea5d236fedf6eb58db72d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "521e52f5ec56cc96bc4ffb721ec55f48e4e73946311d91c813183b0aae88c666"
  end

  depends_on "coreutils" => :build
  depends_on "go" => :build
  depends_on "socat"

  uses_from_macos "krb5"

  def install
    arch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s
    os = OS.kernel_name.downcase

    # See https://github.com/golang/go/issues/26487
    ENV.O0 if OS.linux?

    system "make", "cross-build-#{os}-#{arch}", "OS_GIT_VERSION=#{version}", "SHELL=/bin/bash"
    bin.install "_output/bin/#{os}_#{arch}/oc"

    bash_completion.install "contrib/completions/bash/oc"
    zsh_completion.install "contrib/completions/zsh/oc" => "_oc"
  end

  test do
    (testpath/"kubeconfig").write ""
    system "KUBECONFIG=#{testpath}/kubeconfig #{bin}/oc config set-context foo 2>&1"
    context_output = shell_output("KUBECONFIG=#{testpath}/kubeconfig #{bin}/oc config get-contexts -o name")

    assert_match "foo", context_output
  end
end