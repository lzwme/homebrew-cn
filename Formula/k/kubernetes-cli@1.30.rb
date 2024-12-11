class KubernetesCliAT130 < Formula
  desc "Kubernetes command-line interface"
  homepage "https:kubernetes.iodocsreferencekubectl"
  url "https:github.comkuberneteskubernetes.git",
      tag:      "v1.30.8",
      revision: "354eac776046f4268e9989b21f8d1bba06033379"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^v?(1\.30(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "004cf63611454d5b6cfc5f5340f8440971dd18d0d4d9bbfa7cfa4054852bcd0a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5bc226969698879e8ec846df6112cef400c519dcd2be1966f83b46682a36439d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f38616b5af94b2bec2e15d9a6c87738e20e86adbf7b4f34daef6198b8ea7e9a5"
    sha256 cellar: :any_skip_relocation, sonoma:        "6b48291b33d877f785b7037431c1c09a566b42f79ac9b2290bc5ecb28a60e142"
    sha256 cellar: :any_skip_relocation, ventura:       "3a462cf28a5f53279a088595443a3f89f3567014a6884539adf6ddf2310803a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a306cbca48aa7936048b52c67f11a3331bcba1dc7a088d9c15a165ca79cf835a"
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