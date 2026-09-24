class KubernetesCliAT135 < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/docs/reference/kubectl/"
  url "https://github.com/kubernetes/kubernetes.git",
      tag:      "v1.35.9",
      revision: "329000efd0b26bd78155e51e4df449130f0fca00"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(1\.35(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7b9ddba8b9b09767c6a1f3e6690fb47ae12cf3d7efc8db51b73f1f5a0a4052bd"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "bc5032bde36cb82ebd271fb26c275ad19b7668f7d2b9747ba9b8f32437978c26"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e52c5dd4c27cebe726eab45003f052db71565b813fa8e0ea990ef188babf0bc5"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e865e301e0708195bd41afa3cc05875f25946cce63e32dbf58a98ac696955159"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "5c611962400937dd56a52f5afb8cc6b4ea7e808ef48bb461dd38d869f84d937c"
  end

  keg_only :versioned_formula

  # https://kubernetes.io/releases/patch-releases/#1-35
  disable! date: "2027-02-28", because: :deprecated_upstream

  depends_on "go" => :build

  on_macos do
    depends_on "bash" => :build
    depends_on "coreutils" => :build
  end

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