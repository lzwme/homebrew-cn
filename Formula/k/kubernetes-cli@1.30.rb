class KubernetesCliAT130 < Formula
  desc "Kubernetes command-line interface"
  homepage "https:kubernetes.iodocsreferencekubectl"
  url "https:github.comkuberneteskubernetes.git",
      tag:      "v1.30.4",
      revision: "a51b3b711150f57ffc1f526a640ec058514ed596"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^v?(1\.30(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "27e0349cdb04e7b47ae73472f08ac6c5ac06444109987eb909c46d6f23b3ce07"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8284c1bf2bb500bffed302c5382c24cb462637aa3b8516f53b457bd1be8b1706"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3b8489e9877528d93651ecd12a46b986b3376a085beb2ed2505be4ca6c630bef"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2f76710fa4e8aefea76f3e59f917fbbf71a7488c19f0e70aa9bda9469ba157a5"
    sha256 cellar: :any_skip_relocation, sonoma:         "5e863b0d2352f410af89486c8b15d5849c3397adf2bc63421837c9bd054528cc"
    sha256 cellar: :any_skip_relocation, ventura:        "fe1db3b0aa4559ed138d7a576f41a60238de7d5254d71e37c22e9a36c165e87e"
    sha256 cellar: :any_skip_relocation, monterey:       "14a373dab7fbb8c808f8ff584697357fde3bc6991c1fe6f6d02f211bb740b830"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8d5f23a188fdf883f37510c5b5fafe55d6e431d3d803f8ae2f1933a28f1f5f78"
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