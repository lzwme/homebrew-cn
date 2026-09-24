class KubernetesCli < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/docs/reference/kubectl/"
  url "https://github.com/kubernetes/kubernetes.git",
      tag:      "v1.37.1",
      revision: "f78e722310e50bcaca9276be22276d9e91d91308"
  license "Apache-2.0"
  head "https://github.com/kubernetes/kubernetes.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5631eb9a9fbf75037add6275f9a9acf58acbf963fa2b45725dc59f8cd9932546"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "64f0c5b577f582095f4263847a6fd9bc10c7ecf1768e039777a1428b2e13fc40"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1c09f67bcd5823ef6320bd4af45ff1d325b0f75f4cd15970c7a2db8dcf96fc7e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8ce82f771ec0203f9559d068fe5e2f3dac66ae0e68b862e080442e3bb56adee1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "f71f9ac3329741d2e228a4b7d19f35caad1fedfc1a47b28e32c41194c7ec2868"
  end

  depends_on "go" => :build

  on_macos do
    depends_on "bash" => :build
    depends_on "coreutils" => :build
  end

  # Go dependencies are vendored
  deny_network_access!

  def install
    ENV.prepend_path "PATH", formula_opt_libexec("coreutils")/"gnubin" if OS.mac? # needs GNU date
    ENV["FORCE_HOST_GO"] = "1"
    system "make", "WHAT=cmd/kubectl"
    bin.install "_output/bin/kubectl"

    generate_completions_from_executable(bin/"kubectl", shell_parameter_format: :cobra)

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