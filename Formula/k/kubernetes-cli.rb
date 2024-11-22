class KubernetesCli < Formula
  desc "Kubernetes command-line interface"
  homepage "https:kubernetes.iodocsreferencekubectl"
  url "https:github.comkuberneteskubernetes.git",
      tag:      "v1.31.3",
      revision: "c83cbee114ddb732cdc06d3d1b62c9eb9220726f"
  license "Apache-2.0"
  head "https:github.comkuberneteskubernetes.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "302d2ecf90f6c962e96b6345d4031551ec0198c4db1c1cfb0ea83b87510ec6cd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "118193fcf9a4f91c21f0583589388ae6dc287963e591642f7d69418a94a71a20"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "788e97ca595658075195630b45d156fe2c08d1cd39b3fa6a837d2a86fcbb1555"
    sha256 cellar: :any_skip_relocation, sonoma:        "fd154ae205719c58f90bdb2a51c63e428c3bf941013557908ccd322d7488fb67"
    sha256 cellar: :any_skip_relocation, ventura:       "9272cee534ea7bbad5b85c5e337055acbc1511b3ee926cd0415c47c1f494603d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e9040db1000ae3ab70116fa36f2feda3e3dd3deda862633181f14ac95bf95797"
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