class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.github.io/cd"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v2.7.8",
      revision: "92949f6033080f2fba9a9654f46592fb71982770"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5b8fe33553ffa6e3920e3bdeb805b2ebcf43e18c085c19d7c11d38783d5a8529"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a568cdb051d16f31205e17e11a115b5af98e043f30c10e54e7c944055ab1793a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e550182bea74db39412fd8649efc7272ed8a52f3db25c311ea767cb1460e5b62"
    sha256 cellar: :any_skip_relocation, ventura:        "9aaf18a1778481557d68996b7c3f54efe29e0932bcbec309ed1b23420db054f9"
    sha256 cellar: :any_skip_relocation, monterey:       "585a89bb09f24cd7e56a5e63f46bbf747ce6fa6c86d80cab5712658c19587433"
    sha256 cellar: :any_skip_relocation, big_sur:        "031ea5b2e7a83f8619db778d0778f782c914879a0f482c34d4d27007d5d85349"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "503705ac93bdf9b8fb107301abdabcbb4179660fca12431f93652f68ed8875c9"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "yarn" => :build

  def install
    system "make", "dep-ui-local"
    with_env(
      NODE_ENV:        "production",
      NODE_ONLINE_ENV: "online",
    ) do
      system "yarn", "--cwd", "ui", "build"
    end
    system "make", "cli-local"
    bin.install "dist/argocd"

    generate_completions_from_executable(bin/"argocd", "completion", shells: [:bash, :zsh])
  end

  test do
    assert_match "argocd controls a Argo CD server",
      shell_output("#{bin}/argocd --help")

    # Providing argocd with an empty config file returns the contexts table header
    touch testpath/"argocd-config"
    (testpath/"argocd-config").chmod 0600
    assert_match "CURRENT  NAME  SERVER\n",
      shell_output("#{bin}/argocd context --config ./argocd-config")
  end
end