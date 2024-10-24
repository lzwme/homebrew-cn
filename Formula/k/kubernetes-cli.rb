class KubernetesCli < Formula
  desc "Kubernetes command-line interface"
  homepage "https:kubernetes.iodocsreferencekubectl"
  url "https:github.comkuberneteskubernetes.git",
      tag:      "v1.31.2",
      revision: "5864a4677267e6adeae276ad85882a8714d69d9d"
  license "Apache-2.0"
  head "https:github.comkuberneteskubernetes.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "96b8120ae14250531c3263f9af97b94e77f812b3966ba7ac7de83c4ce19c866c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bf453d4b33ff0abb80139f94368cef62c476100232d77cadd6a05401ed9bbe69"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "570f9e02dd1419c27b85261c49df3ca731bc57935671613948dc119b54688fb6"
    sha256 cellar: :any_skip_relocation, sonoma:        "cb31f97a00ab3e823f3f5d978aa6acc26900b0ca493162e96f014733d6a6eed7"
    sha256 cellar: :any_skip_relocation, ventura:       "9bb20c503fd7391fb50e6a007c9175806801f35cb0631e25391fa598702a0909"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f33e7481d74b0ea80acec035296206d2c3d26a234f335467dbfeec478a25cc2c"
  end

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