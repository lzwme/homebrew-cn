class KubernetesCliAT132 < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/docs/reference/kubectl/"
  url "https://github.com/kubernetes/kubernetes.git",
      tag:      "v1.32.11",
      revision: "2195eae9e91f2e72114365d9bb9c670d0c08de12"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(1\.32(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3c5b15c493f41e83404a528211fa9366ebb20aa38eda77c244676e78449c9d96"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "251d61ae01c7d33788837c78cd946e602a68bbebb76f8c004cf130cf11ff5a36"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0377279678dd28ad223afa1fd841dbc11d61c10e9eb1ab5ade1d68516e2f6431"
    sha256 cellar: :any_skip_relocation, sonoma:        "3cfce511f3e72f761213491819acbb6efa0c49f423035ec59b450d1e29157bb1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "673a77dd7224fe8d8e188735970119b3f424cdf11307437536dc75562ad56044"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bfad24a7f567188d98513622ae421417071d51a8cbdc8f49d611149a9f26cfad"
  end

  keg_only :versioned_formula

  # https://kubernetes.io/releases/patch-releases/#1-32
  disable! date: "2026-02-28", because: :deprecated_upstream

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