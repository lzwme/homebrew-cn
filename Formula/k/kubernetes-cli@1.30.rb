class KubernetesCliAT130 < Formula
  desc "Kubernetes command-line interface"
  homepage "https:kubernetes.iodocsreferencekubectl"
  url "https:github.comkuberneteskubernetes.git",
      tag:      "v1.30.10",
      revision: "ccc69071da5040a2bafc1ba9c4775782e0f4e55c"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^v?(1\.30(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b6f0979b61b0130b2bf608ef2cf7ff26de6a14e7411bc7ee292c585c5089c694"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e3009fa7ae5c474393286a33dd8ef1fc8019b3017bda48c9b1c84b6d61acf944"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5588a98767e66a52a96be8f28e1206f18aa1233d4d5516af07a8caa016e0c8c7"
    sha256 cellar: :any_skip_relocation, sonoma:        "235702b404256f518766175abd9117d48c4b175c3b72b5add4e9d143af6cfd7d"
    sha256 cellar: :any_skip_relocation, ventura:       "c0b5356a6352f1067d9f13158e17abedaffb4ee7b3689791c31d589e7bc96e3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e00e7ecbe1c7b3024daa21a716de6e9d4b3174b005da8d5035d79f5f4f0bde71"
  end

  keg_only :versioned_formula

  # https:kubernetes.ioreleasespatch-releases#1-30
  disable! date: "2025-06-28", because: :deprecated_upstream

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