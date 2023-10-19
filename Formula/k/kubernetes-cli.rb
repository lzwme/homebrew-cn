class KubernetesCli < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/docs/reference/kubectl/"
  url "https://github.com/kubernetes/kubernetes.git",
      tag:      "v1.28.3",
      revision: "a8a1abc25cad87333840cd7d54be2efaf31a3177"
  license "Apache-2.0"
  head "https://github.com/kubernetes/kubernetes.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9229655d9ccb521f3c1986077a4826f2ba3049357623f39c72c53b4253fe08ad"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b403d57f3731fbafcbd44113fdf7823d1992c4a6c7eb1dcc8206e8dae62e8368"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a43a05e32c5d901c81f049b37f224dc07c3f5043be60f97ffd11a57a3de402d3"
    sha256 cellar: :any_skip_relocation, sonoma:         "3dbba434b4e80660da2378d4079d05eca7b51af5a88ed1431b0278b995c1e3c6"
    sha256 cellar: :any_skip_relocation, ventura:        "c61d003ef423897583d3e66bd1a5e97bb39b2c010fd7ed5a280fdf73adfb1c73"
    sha256 cellar: :any_skip_relocation, monterey:       "dd65de10248c26946dea7f246a59f646c4a21f8ceb635d13e6876587464b1f48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dcfbc22c8dbe24daae61beba4aa4e6c7e74d482b05fa8a49312fbda188aef13c"
  end

  depends_on "bash" => :build
  depends_on "coreutils" => :build
  depends_on "go" => :build

  uses_from_macos "rsync" => :build

  def install
    # Don't dirty the git tree
    rm_rf ".brew_home"

    ENV.prepend_path "PATH", Formula["coreutils"].libexec/"gnubin" # needs GNU date
    system "make", "WHAT=cmd/kubectl"
    bin.install "_output/bin/kubectl"

    generate_completions_from_executable(bin/"kubectl", "completion", base_name: "kubectl")

    # Install man pages
    # Leave this step for the end as this dirties the git tree
    system "hack/update-generated-docs.sh"
    man1.install Dir["docs/man/man1/*.1"]
  end

  test do
    run_output = shell_output("#{bin}/kubectl 2>&1")
    assert_match "kubectl controls the Kubernetes cluster manager.", run_output

    version_output = shell_output("#{bin}/kubectl version --client --output=yaml 2>&1")
    assert_match "gitTreeState: clean", version_output
    if build.stable?
      revision = stable.specs[:revision]
      assert_match revision.to_s, version_output
    end
  end
end