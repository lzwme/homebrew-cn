class KubernetesCliAT130 < Formula
  desc "Kubernetes command-line interface"
  homepage "https:kubernetes.iodocsreferencekubectl"
  url "https:github.comkuberneteskubernetes.git",
      tag:      "v1.30.7",
      revision: "0c76c645d5a665cfeb736719b1cc47354193dc9a"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^v?(1\.30(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dba971ed2f122debbc024a8027a6e3bf0d01c0dccb5c6c917b5171a251d00cc8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a7195019673a0334352ba2525fd959f0b5f724036e662a02cf5843ff3370af63"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "92f34a26e915c67a2915242eaa4e56a8e58612d7f20e0f9668467d7e8d7ff1b4"
    sha256 cellar: :any_skip_relocation, sonoma:        "f261806655878a20999696f0f28dc35faa163feffb41d68d1aedcf0daab6abea"
    sha256 cellar: :any_skip_relocation, ventura:       "9befaf2c5265339ea987b78721d3ebf3e190bfa1c2df357cdda74e949d9db23f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fc6adb776e3abfad558c9aa18f0d18141b8740c570077ac9932f83601e33be5c"
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