class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.github.io/cd"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v2.7.5",
      revision: "a2430af1c356b283e5e3fc5bde1f5e2b5199f258"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d2a51076dbd296e5b119627c7ff0b70475d97c805fdf2ac446fe366ca1818ac2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "df22a5dc65688c0e99041f743437a2113c1cc8c760f62a9f2aa0d00169c43ea5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a345e02715642d060d75c88db9c3b44bf7bfc3311750f3a78473b19a59a3a872"
    sha256 cellar: :any_skip_relocation, ventura:        "605151d0386a4c360ab39d4a1827b28b696a2d1c5f160f93ca78d92ae046c440"
    sha256 cellar: :any_skip_relocation, monterey:       "ec34a00c4a53b498facf521c208ae760cc554ce7d00e89cf35b721dde290f6ce"
    sha256 cellar: :any_skip_relocation, big_sur:        "6896c21aaca9f1beec5f6dc9b1411e5bc9eec8219283daeacaebcb3f577babc6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1a8ebe390820f8844ae15c4ccc11118efae7b8373b27ba5c11fd7f9814fb3852"
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