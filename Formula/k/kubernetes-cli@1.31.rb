class KubernetesCliAT131 < Formula
  desc "Kubernetes command-line interface"
  homepage "https:kubernetes.iodocsreferencekubectl"
  url "https:github.comkuberneteskubernetes.git",
      tag:      "v1.31.4",
      revision: "a78aa47129b8539636eb86a9d00e31b2720fe06b"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^v?(1\.31(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "32b0852f5247fb4526173627ae49c743c569705c42c75723c2b56e25169b75c5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9095e41598fe219e5b29898356c508c77845192f210d75de739c3872d02a70c9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "506b5ef26d3d962a31b2952a5e435e8c72f3125fbc9e23a35cce23a0d5d2d781"
    sha256 cellar: :any_skip_relocation, sonoma:        "7cc1c09b5b59047de600660da77e683c3257800463339aeb050e8cee89c9b970"
    sha256 cellar: :any_skip_relocation, ventura:       "e06c7f463164d0779af0d4ac092bbbaa5dca2fc0d7be464a7af698ddaca14455"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5db948a029e9dff76e603a4ca806feff2d088344ae6159ad23c73ea4d24a61e9"
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
    assert_match stable.specs[:revision].to_s, version_output
  end
end