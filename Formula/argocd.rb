class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.github.io/cd"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v2.7.3",
      revision: "e7891b899a35dca06ae94965ea5ae2a86b344848"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "395f44f5711d0eaeef908fd5948111084c9b7c0e45b2d7f43609085d22c841af"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "09f725d55e2d59574962506cc189b57f1c4b98f7cc432910428d987c233fe5a2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "19df525dfd90e72e7d1cc7b6d3cd893cc3255ec85655a7e8bbe4c7ac19142034"
    sha256 cellar: :any_skip_relocation, ventura:        "5c3dbde37ee83551ef975fd5307bb360bb07e8f849704a4f681d4af1c978756a"
    sha256 cellar: :any_skip_relocation, monterey:       "173a7d23d1062ae185aa44dcf77591aaf52b28e39b617802ce163edf0e66f72f"
    sha256 cellar: :any_skip_relocation, big_sur:        "9594e26c14d2f271f31b802b74ce5eb6d8ddc9fed1e3029f358ef83bf9ea9ec0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6be3e80ce54517f4e39038bdb2e20531ed21c0e30684b3c952f49faa733067d5"
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