class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.github.io/cd"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v2.7.0",
      revision: "c592219140e5f48b6849f3f9a8f7aed6047d54fa"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7969ef2cd501c860ae0acb36715cb87022335154f29939b47c640bf0d2975502"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7c01ac67d17b07810ff83fc24ef75e7af583eeae008d51ed7beafef00862e018"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fd43797e6d4768736e4ea5530165592497fcd486b720d8bffa30e7eece967fee"
    sha256 cellar: :any_skip_relocation, ventura:        "6935c8f0e9a3fa9cf38f85fd7af8509c203d43555bb63a93cd52f9a191a1e6fc"
    sha256 cellar: :any_skip_relocation, monterey:       "eeca8d2f520d3416fccaeb78333ff1b19ba8f2d6066a72e0bf4906ba189a191c"
    sha256 cellar: :any_skip_relocation, big_sur:        "8c8fec01ec1855fe65754b2092d6fd3b58653ba0b708b9ffcd58a8819578c43a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4576713eb19c90dfeb9b933f107baa318f4de6e0b0fb464eafaf889fffbce71f"
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