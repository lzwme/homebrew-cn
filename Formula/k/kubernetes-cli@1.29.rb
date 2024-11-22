class KubernetesCliAT129 < Formula
  desc "Kubernetes command-line interface"
  homepage "https:kubernetes.iodocsreferencekubectl"
  url "https:github.comkuberneteskubernetes.git",
      tag:      "v1.29.11",
      revision: "960a2f019319ab5f7ac1c256efcc180a4113343a"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^v?(1\.29(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c2bf274c6115a102066bb5810b491e28f1e25a3843d42d60d90234eb8d5fbbec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "01f0cc8d3e752ea36d8a1e04574232f3f5cd14c2d83ebc93b03fadecead5357c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8623c11d7afb54cf209ad0b90200328e3cdd7526adc3024195f725417eb837f3"
    sha256 cellar: :any_skip_relocation, sonoma:        "9dbacd9ab5001e606ebbcc7b58fdd3ad050b9d8200d3880df0c5e9bb5efcc5ed"
    sha256 cellar: :any_skip_relocation, ventura:       "a1cdaa71bb9d71a2d0cb6dd913bd836bce625b643a46bfd3ab5dec576ca649a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "493c1636218ea586b510fd4b4cd733489425cbff0590b54c67b8cba8d938596a"
  end

  keg_only :versioned_formula

  # https:kubernetes.ioreleasespatch-releases#1-29
  disable! date: "2025-02-28", because: :deprecated_upstream

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