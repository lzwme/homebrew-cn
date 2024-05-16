class KubernetesCliAT129 < Formula
  desc "Kubernetes command-line interface"
  homepage "https:kubernetes.iodocsreferencekubectl"
  url "https:github.comkuberneteskubernetes.git",
      tag:      "v1.29.4",
      revision: "55019c83b0fd51ef4ced8c29eec2c4847f896e74"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^v?(1\.29(?:\.\d+)+)$i)
  end

  keg_only :versioned_formula

  # https:kubernetes.ioreleasespatch-releases#1-29
  disable! date: "2025-02-28", because: :deprecated_upstream

  depends_on "bash" => :build
  depends_on "coreutils" => :build
  depends_on "go@1.21" => :build

  uses_from_macos "rsync" => :build

  def install
    ENV.prepend_path "PATH", Formula["coreutils"].libexec"gnubin" # needs GNU date
    system "make", "WHAT=cmdkubectl"
    bin.install "_outputbinkubectl"

    generate_completions_from_executable(bin"kubectl", "completion", base_name: "kubectl")

    # Install man pages
    # Leave this step for the end as this dirties the git tree
    system "hackupdate-generated-docs.sh"
    man1.install Dir["docsmanman1*.1"]
  end

  test do
    run_output = shell_output("#{bin}kubectl 2>&1")
    assert_match "kubectl controls the Kubernetes cluster manager.", run_output

    version_output = shell_output("#{bin}kubectl version --client --output=yaml 2>&1")
    assert_match "gitTreeState: clean", version_output
    if build.stable?
      revision = stable.specs[:revision]
      assert_match revision.to_s, version_output
    end
  end
end