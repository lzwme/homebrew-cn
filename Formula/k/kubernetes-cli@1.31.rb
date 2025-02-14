class KubernetesCliAT131 < Formula
  desc "Kubernetes command-line interface"
  homepage "https:kubernetes.iodocsreferencekubectl"
  url "https:github.comkuberneteskubernetes.git",
      tag:      "v1.31.6",
      revision: "6b3560758b37680cb713dfc71da03c04cadd657c"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^v?(1\.31(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e8d466a49a64db96deb0e72d7c8b8bd63a216640730f3d0a827d5b6826851c0f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e9ffd9a7552cdf9810f3ab52d6e7f9b2b9a9a85f3da1c5b1139e7a1703756183"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3f2ea59ae9b1e5a90f40f73328692370e4b9233e5aa6cfb42518bd6b7119b1b2"
    sha256 cellar: :any_skip_relocation, sonoma:        "8fabfebd483fc563cb011493bf35db7d4367813b89e2d5d8370d36f3a5942624"
    sha256 cellar: :any_skip_relocation, ventura:       "cabfb3a151423ea126044f1cf3deb2733ec4d6ec7cc248c8d6458b6992f5831a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "84e5457d7d239bf4beed8b14ed347f0ca6280b3b4fc1431e14a3a10b6c2fe7cb"
  end

  keg_only :versioned_formula

  # https:kubernetes.ioreleasespatch-releases#1-31
  disable! date: "2025-10-28", because: :deprecated_upstream

  depends_on "bash" => :build
  depends_on "go" => :build

  uses_from_macos "rsync" => :build

  on_macos do
    depends_on "coreutils" => :build
  end

  def install
    ENV.prepend_path "PATH", Formula["coreutils"].libexec"gnubin" if OS.mac? # needs GNU date
    ENV["FORCE_HOST_GO"] = "1"
    system "make", "WHAT=cmdkubectl"
    bin.install "_outputbinkubectl"

    generate_completions_from_executable(bin"kubectl", "completion")

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
    assert_match stable.specs[:revision].to_s, version_output
  end
end