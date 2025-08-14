class KubernetesCli < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/docs/reference/kubectl/"
  url "https://github.com/kubernetes/kubernetes.git",
      tag:      "v1.33.4",
      revision: "74cdb4273add43f53ddcad2de8ea9fd93c810dc4"
  license "Apache-2.0"
  head "https://github.com/kubernetes/kubernetes.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "716f3c5a26becc117807b2491b325082053fa771fd0bb5e142a162c44126aa8f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fa99dca56a2b7fe14147467de7a515f08bb5b4018691178c3fadd87302d5e540"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9140928b6a3a238065053b2ccf0cba97746d44f5ac21d2665eaabf7f896ae7af"
    sha256 cellar: :any_skip_relocation, sonoma:        "7cc153f4aa0d47fddf768742d2b9a03cdb6a7b38866201763fce92912d9d2287"
    sha256 cellar: :any_skip_relocation, ventura:       "ed10ec7573c8fc1f5b0e740c6c2fce2e1be672ac5be5b5d09eb3df6e62cec6d0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5a4ce465642efccc02b0038755ac0bf8ad1e6f847f70dd86b654b0abeb6fafe5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f9d2a735a67e0ff28ba1f9af4aca795cbc15252293c5f7e9078ba313a80fa2bd"
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