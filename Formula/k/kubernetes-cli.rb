class KubernetesCli < Formula
  desc "Kubernetes command-line interface"
  homepage "https:kubernetes.iodocsreferencekubectl"
  url "https:github.comkuberneteskubernetes.git",
      tag:      "v1.29.1",
      revision: "bc401b91f2782410b3fb3f9acf43a995c4de90d2"
  license "Apache-2.0"
  head "https:github.comkuberneteskubernetes.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5ad36ac275d7b89636e63323f775a1d08ba35030f73ed9946de0ec50da498059"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "75b99f25cdd2b9c8495bbf2d2e44daf3db5b9f06f2f2d7d895c531fe5a1f2300"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "679c571a121f5ad8dc463a8a42d8afa08f0550ea7d274c535ceafe381e4db4c9"
    sha256 cellar: :any_skip_relocation, sonoma:         "9396cb46c9606a28d44a591394af24dea3ff2c730a0c5b6f385fbf3d7748e1b7"
    sha256 cellar: :any_skip_relocation, ventura:        "2d2684549cfaa9fb4cc770e436bee27f3e4296cae6e93115a3eb9bc16c885521"
    sha256 cellar: :any_skip_relocation, monterey:       "f20f8694012ce9323cad68c34ffb6d24c29e38c255a8547c17d4df5959d807c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8bb746fd529facd2e9bd87f1fe3323c95d1dc90adca7138ef2b5b7c00df2e523"
  end

  depends_on "bash" => :build
  depends_on "coreutils" => :build
  depends_on "go" => :build

  uses_from_macos "rsync" => :build

  def install
    # Don't dirty the git tree
    rm_rf ".brew_home"

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