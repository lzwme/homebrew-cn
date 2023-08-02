class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.github.io/cd"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v2.7.10",
      revision: "469f25753b2be7ef0905a11632a6382060bcae99"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8bc16c1814bf96ef7c414718307e49de98e13ac6ec02d729cd8dbefb6695e0fc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "083dc21799a6124e3a5fa8f84fd19991e9fd39b42cd1b4da15841547a17631df"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "26cadcc3c0fcaa36798e0a0ab714ee1432d492611872c343bbd5ce4cb03cf8f1"
    sha256 cellar: :any_skip_relocation, ventura:        "d111e6e837ab899141d4147689efc8a54f5e34ce6930b4ff35e57f5d6a9fd863"
    sha256 cellar: :any_skip_relocation, monterey:       "881f1f3b56fa3c91455c70888127efa77ed24db77d5f08433cc10a3c0a9c806c"
    sha256 cellar: :any_skip_relocation, big_sur:        "da59f678448e6030bb30901b4528c11772c1ed534c065c008257fe1e2fd51e53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ebdc04cd8db48a764f30863da31907a4ae310e263cc27274f28a9f9c7ef6d792"
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